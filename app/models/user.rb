# The User class represents a registered user of the app.
# Right now, every registered user is a User. (i.e. only one authenticatable resource exists)
class User < ApplicationRecord
  # Invoke devise modules. Others available are:
  # :timeoutable
  #
  # Read about what each module does at https://github.com/plataformatec/devise.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :omniauthable, omniauth_providers: [:facebook, :twitter]

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
  validates :link_to_facebook, :link_to_google_plus, :link_to_twitter, allow_nil: true, length: { maximum: 1000 }, format: { with:
    /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,63}(:[0-9]{1,5})?(\/.*)?\z/ix , message: "is not a valid url" }
  # Validate the attached image (provided by the gem paperclip) is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # Overriding the devise default to make it use ActiveJob as
  # read here: https://github.com/plataformatec/devise#activejob-integration
  # def send_devise_notification notification, *args
  #   devise_mailer.send(notification, self, *args).deliver_later
  # end
end
