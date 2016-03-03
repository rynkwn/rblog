class ServiceMailer < ApplicationMailer
  
  # For anytime I want to send a typical email.
  def email(subject, receiver, content)
    CLIENT.deliver(
      :subject => subject,
      :to      => receiver,
      :from    => SENDER_SIGNATURE,
      :html_body => content
      )
  end
  
  # A daily messenger email.
  def daily_messenger(receiver, subject, content)
    CLIENT.deliver(
      :subject => subject,
      :to      => receiver,
      :from    => SENDER_SIGNATURE,
      :html_body => content
      )
  end
end
