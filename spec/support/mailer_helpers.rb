module MailerHelpers
  def last_email
    ActionMailer::Base.deliveries.last
  end
  
  def reset_email
    ActionMailer::Base.deliveries = []
  end

  def deliveries
    ActionMailer::Base.deliveries
  end

  # Raises an exception if not exactly 1 email was sent and
  # returns the email address of the receiver.
  def only_email_to
    unless deliveries.length == 1
      Kazus.log "NotExactlyOneEmail", deliveries: deliveries
      raise "NotExactlyOneEmail"
    end
    deliveries.first.to
  end
end
