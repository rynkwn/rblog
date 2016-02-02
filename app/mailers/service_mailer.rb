class ServiceMailer < ApplicationMailer
  
  # A standard email.
  def daily_messenger(receiver, content)
    mail(
      :subject => 'Your Daily Messenger for ' + Date.today,
      :to      => receiver,
      :from    => SENDER_SIGNATURE,
      :text_body => "Needed for Heroku",
      :body => content
    )
  end
end
