# Preview all emails at http://localhost:3000/rails/mailers/devise/mailer
class Devise::MailerPreview < ActionMailer::Preview
  def confirmation_instructions
    token = "iorwfe459okladwgre"
    record = FactoryGirl.build(:user, :unconfirmed)
    options = {}
    Devise::Mailer.confirmation_instructions(record, token, options)
  end

  def reset_password_instructions
    token = "iorwfe459okladwgre"
    record = FactoryGirl.build(:user)
    options = {}
    Devise::Mailer.reset_password_instructions(record, token, options)
  end

  def unlock_instructions
    token = "iorwfe459okladwgre"
    record = FactoryGirl.build(:user)
    options = {}
    Devise::Mailer.unlock_instructions(record, token, options)
  end

  def password_change
    record = FactoryGirl.build(:user)
    options = {}
    Devise::Mailer.password_change(record, options)
  end
end
