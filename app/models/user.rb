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
end
