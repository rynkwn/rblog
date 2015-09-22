class Bloghistory < ApplicationMailer
  
  def blog_record(subject, date, tags, content)
    mail(
      :subject => 'BLOG: ' + subject + ' - ' + date,
      :to => 'rynkwn@gmail.com',
      :from => SENDER_SIGNATURE,
      :tag => tags,
      :text_body => "Needed for Heroku",
      :body => content
    )
  end
  
  # A standard email.
  def standard(subject, content)
    mail(
      :subject => 'BLOG: ' + subject,
      :to      => 'rynkwn@gmail.com',
      :from    => SENDER_SIGNATURE,
      :text_body => "Needed for Heroku",
      :body => content
    )
  end
end
