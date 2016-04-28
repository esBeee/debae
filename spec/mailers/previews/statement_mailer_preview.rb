# Preview all emails at http://localhost:3000/rails/mailers/statement_mailer
class StatementMailerPreview < ActionMailer::Preview
  def new_argument_email
    link = StatementArgumentLink.first || FactoryGirl.create(:statement_argument_link)
    StatementMailer.new_argument_email(link)
  end
end
