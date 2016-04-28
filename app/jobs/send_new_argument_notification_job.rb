class SendNewArgumentNotificationJob < ApplicationJob
  queue_as :default

  def perform statement_argument_link
    statement = statement_argument_link.statement
    argument = statement_argument_link.argument
    receiver = statement.user
    
    # Send an email notification if the receiver's settings allow for it and
    # the user is not creator of the new argument.
    if receiver.email_if_new_argument && statement.user_id != argument.user_id
      StatementMailer.new_argument_email(statement_argument_link).deliver_now
    end
  end
end
