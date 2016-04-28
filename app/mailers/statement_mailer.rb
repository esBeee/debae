class StatementMailer < ApplicationMailer
  default from: "no-reply@debae.de"

  def new_argument_email statement_argument_link
    @statement = statement_argument_link.statement
    @argument = statement_argument_link.argument
    @pro_or_con = statement_argument_link.is_pro_argument ? "pro" : "contra"
    receiver = statement_argument_link.statement.user

    mail to: receiver.email,
      subject: I18n.t("mailers.statements.new_argument_email.subject",
        default: "There's a new argument for one of your statements!")
  end
end
