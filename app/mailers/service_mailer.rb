class ServiceMailer < ApplicationMailer
  
  # For anytime I want to send a typical email.
  def email(subject, receiver, content)
    mail(
      :subject => subject,
      :to      => receiver,
      :from    => SENDER_SIGNATURE,
      :text_body => "Needed for Heroku",
      :body => content
    )
  end
  
  # A daily messenger email.
  def daily_messenger(receiver, content)
    mail(
      :subject => 'Your Daily Messenger for ' + Date.current.in_time_zone.strftime("%a, %b %d"),
      :to      => receiver,
      :from    => SENDER_SIGNATURE,
      :text_body => "Needed for Heroku",
      :body => content
    )
  end
end
