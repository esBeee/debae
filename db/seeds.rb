# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

email = "a@b.de"
user = User.find_by(email: email)
if user.nil?
  user = FactoryGirl.create(:user, email: email)
end
puts "User #{email} with password #{user.password} now exists."

# Create statements
# FactoryGirl.create_list(:statement, 45)
# puts "45 top level statements created."
