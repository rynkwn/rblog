class Bloghistory < ApplicationMailer
  
  def blog_record(subject, date, tags, content)
    mail(
      :subject => 'BLOG: ' + subject + ' - ' + date,
      :to => 'rynkwn@gmail.com',
      :from => SENDER_SIGNATURE,
      :tag => tags,
      :body => content
    )
  end
  
  # A standard email.
  def standard(subject, content)
    mail(
      :subject => 'BLOG: ' + subject,
      :to      => 'rynkwn@gmail.com',
      :from    => SENDER_SIGNATURE,
      :body => content
    )
  end
end
