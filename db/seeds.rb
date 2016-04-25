# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def user_foc email
  user = User.find_by(email: email)
  if user.nil?
    user = FactoryGirl.create(:user, email: email)
  end
  puts "User #{email} with password 'foobar12' now exists."
  user
end

def statement_foc user, body
  Statement.find_by(body: body) || FactoryGirl.create(:statement, user: user, body: body)
end

def argument_statement user, statement, pro_or_contra, body
  unless statement.arguments.find_by(body: body)
    argument = FactoryGirl.create(:statement, user: user, body: body)
    FactoryGirl.create(:statement_argument_link, pro_or_contra, statement: statement, argument: argument)
  end
  argument
end

user = user_foc("a@b.de")
user_1 = user_foc("c@g.de")
user_2 = user_foc("e@a.de")
user_3 = user_foc("v@w.de")
user_4 = user_foc("a@w.de")

# Create statements
# FactoryGirl.create_list(:statement, 45)
# puts "45 top level statements created."

# FactoryGirl.create(:statement, user: user, body: "Als Bundesrepublik Deutschland Waffen nach Saudi-Arabien zu exportieren ist unmoralisch")
# FactoryGirl.create(:statement, user: user, body: "Ohne gezielte Maßnahmen, wird die Schere zwischen Arm und Reich in westlichen Ländern " +
#   "unaufhörlich auseinanderdriften")
# FactoryGirl.create(:statement, user: user, body: "Debae durch Werbung zu finanzieren ist besser als durch Spenden")
# FactoryGirl.create(:statement, user: user, body: "Debae durch Werbung zu finanzieren ist besser als durch Nutzerbeiträge")

statement = statement_foc(user, "Merkels Entscheidung, die Ermächtigung für Ermittlungen gegen Jan Böhmermann nach §103 zu erteilen war falsch")
statement_0 = argument_statement(user, statement, :pro, "Für das Beleidigen von Erdogan sollte man nicht höher bestraft werden, " +
  "als für das Beleidigen anderer Personen")
statement_1 = argument_statement(user, statement, :contra, "Eine Entscheidung gegen Ermittlungen hätte das Prinzip der Gewaltenteilung verletzt")
statement_2 = argument_statement(user, statement, :pro, "Für das beleidigen von Erdogan sollte man nicht höher bestraft werden, " +
  "als für das Beleidigen anderer Personen")

