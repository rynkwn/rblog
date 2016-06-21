class Bloghistory < ApplicationMailer
  
  def blog_record(subject, date, tags, content)
    CLIENT.deliver(
      :subject => 'BLOG: ' + subject + ' - ' + date,
      :to => 'rynkwn@gmail.com',
      :from => SENDER_SIGNATURE,
      :tag => tags,
      :text_body => content
      )
  end
  
  # Sending an analytics email home.
  def analytics_email(start_date, end_date, content)
    CLIENT.deliver(
      :subject => 'BLOG ANALYTICS: ' + start_date + ' - ' + end_date,
      :to      => 'rynkwn@gmail.com',
      :from    => SENDER_SIGNATURE,
      :text_body => content.to_s
      )
  end
  
  # A standard email.
  def standard(subject, content)
    CLIENT.deliver(
      :subject => 'BLOG: ' + subject,
      :to      => 'rynkwn@gmail.com',
      :from    => SENDER_SIGNATURE,
      :text_body => content
      )
  end
end
