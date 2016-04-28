# The User class represents a registered user of the app.
# Right now, every registered user is a User. (i.e. only one authenticatable resource exists)
class User < ApplicationRecord
  # Invoke devise modules. Others available are:
  # :timeoutable
  #
  # Read about what each module does at https://github.com/plataformatec/devise.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :omniauthable, omniauth_providers: [:facebook]

  has_many :statements
  has_many :votes
  has_many :comments

  # This method (provided by the gem paperclip) associates the attribute ":avatar" with a file attachment.
  # Define here in what formats the avatars will be saved. You can display a format
  # in view like so: <%= image_tag resource.avatar.url(:original) %>.
  # Format :original is always available.
  # => Formats ending on '#' always make sure that the image is a square.
  has_attached_file :avatar, default_url: "default_avatars/:style.png", styles: {
    thumb: '100x100#',
    square: '200x200#',
    medium: '300x300>'
  }

  validates :name, presence: true, length: { in: 2..70 }
  # Validate the attached image (provided by the gem paperclip) is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # Overriding the devise default to make it use ActiveJob as
  # read here: https://github.com/plataformatec/devise#activejob-integration
  # def send_devise_notification notification, *args
  #   devise_mailer.send(notification, self, *args).deliver_later
  # end

  # Gets called with the callback data from a OAuth sign in/up.
  # The method tries to match the user with an existing one or
  # creates a new one if none is found.
  # => Always returns a persistent user object. But might be unconfirmed in some cases.
  def self.from_omniauth auth
    Kazus.log "User.from_omniauth got called!", auth_hash: auth

    provider = auth[:provider]
    uid = auth[:uid]

    # According to the docs at https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema,
    # provider and auth is always present. Inform if it is not and return an unsaved
    # user.
    if provider.blank? || uid.blank?
      Kazus.log :fatal, "Insufficient data from OAuth rqeuest", auth_hash: auth
      return User.new
    end

    info = auth[:info]

    # According to the docs at https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema,
    # info is always present. Inform if it is not and prevent the method from
    # throwing an exception.
    if info.nil?
      Kazus.log :warn, "The info hash on an incoming OAuth request is not present", auth_hash: auth
      auth = {} # Make sure that no error gets thrown.
    end

    email = info[:email] # might be nil

    # First, try to find a potentially exisiting user by provider-uid-pair.
    user = User.find_by(provider: provider, uid: uid)

    # If no user was found, try to use the email address to match the user
    # to an existing account, if an email address exists.
    user = User.find_by(email: email) if user.nil? && !email.blank?
    if user
      # If the user was matched by email, make sure provider and uid get saved
      # for this user.
      if user.provider.blank? || user.uid.blank?
        unless user.update(provider: provider, uid: uid)
          Kazus.log :warn, "[2k4l5mlqf] User invalid", user: user, auth_hash: auth
          user.save(validate: false)
        end
      end
    end

    # If still no user was found, create a new one. We're skipping validation
    # for this if necessary, since email is required normally. Also we're confirming
    # the user in any case to not disrupt the OAuth user experience (and also
    # because it's not sure we have got an email anyway).
    if user.nil?
      # Collect all available user information.
      user_attributes = { provider: provider, uid: uid, password: Devise.friendly_token[8,20], confirmed_at: Time.now }
      user_attributes[:email] = email if email
      user_attributes[:name] = info[:name] if info[:name]

      # Create the new user.
      user = User.new(user_attributes)
      unless user.save
        Kazus.log :warn, "User instance created by OAuth data is invalid", user: user
        user.save(validate: false)
      end
    end

    user
  end
end
