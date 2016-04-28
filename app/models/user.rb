# The User class represents a registered user of the app.
# Right now, every registered user is a User. (i.e. only one authenticatable resource exists)
class User < ApplicationRecord
  # Invoke devise modules. Others available are:
  # :omniauthable, :timeoutable
  #
  # Read about what each module does at https://github.com/plataformatec/devise.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :statements
  has_many :votes
  has_many :comments

  validates :name, presence: true, length: { in: 2..70 }
  validates :avatar_url, allow_nil: true, length: { maximum: 1000 }, format: { with:
    /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,63}(:[0-9]{1,5})?(\/.*)?\z/ix , message: "is not a valid url" }

  # Overriding the devise default to make it use ActiveJob as
  # read here: https://github.com/plataformatec/devise#activejob-integration
  # def send_devise_notification notification, *args
  #   devise_mailer.send(notification, self, *args).deliver_later
  # end
end
