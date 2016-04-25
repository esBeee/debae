# The User class represents a registered user of the app.
# Right now, every registered user is a User. (i.e. only one authenticatable resource exists)
class User < ApplicationRecord
  # Invoke devise modules. Others available are:
  # :omniauthable
  #
  # Read about what each module does at https://github.com/plataformatec/devise.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :statements
  has_many :votes
  has_many :comments

  # Overriding the devise default to make it use ActiveJob as
  # read here: https://github.com/plataformatec/devise#activejob-integration
  # def send_devise_notification notification, *args
  #   devise_mailer.send(notification, self, *args).deliver_later
  # end
end
