class StatementMailer < ApplicationMailer
  # The statemnets helpers are required inside the emails.
  add_template_helper(StatementsHelper)

  default from: "info@debae.io"

  def new_argument_email statement_argument_link
    @statement = statement_argument_link.statement
    @argument = statement_argument_link.argument
    @pro_or_con = statement_argument_link.is_pro_argument ? "pro" : "contra"
    receiver = statement_argument_link.statement.user

    # Return if no email address to send the mail to is present.
    return if receiver.email.nil?

    mail to: receiver.email,
      subject: I18n.t("mailers.statements.new_argument_email.subject",
        default: "There's a new argument for one of your statements!")
  end
end
