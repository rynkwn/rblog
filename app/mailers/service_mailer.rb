class ServiceMailer < ApplicationMailer
  
  # For anytime I want to send a typical email.
  def email(subject, receiver, content)
    
    client = Postmark::ApiClient.new(POSTMARK_API_KEY)
    client.deliver(
      :subject => subject,
      :to      => receiver,
      :from    => SENDER_SIGNATURE,
      :html_body => "<h1>test</h1>")
  end
  
  # A daily messenger email.
  def daily_messenger(receiver, subject, content)
    mail(
      :subject => subject,
      :to      => receiver,
      :from    => SENDER_SIGNATURE,
      :text_body => "Needed for Heroku",
      :body => content
    )
  end
end
