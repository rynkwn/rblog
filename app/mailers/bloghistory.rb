class Bloghistory < ApplicationMailer
  
  def blog_record(subject, date, tags, content)
    
    # Concerned about memory leaks, but the mail() function did not appear
    # to be successfully sending the emails in my tests.
    client = Postmark::ApiClient.new(POSTMARK_API_KEY, http_open_timeout: 15)
    
    client.deliver(
      :subject => 'BLOG: ' + subject + ' - ' + date,
      :to => 'rynkwn@gmail.com',
      :from => SENDER_SIGNATURE,
      :tag => tags,
      :text_body => content
      )
      
    client = nil
  end
  
  # A standard email.
  def standard(subject, content)
    client = Postmark::ApiClient.new(POSTMARK_API_KEY, http_open_timeout: 15)
    
    client.deliver(
      :subject => 'BLOG: ' + subject,
      :to => 'rynkwn@gmail.com',
      :from => SENDER_SIGNATURE,
      :text_body => content
      )
      
    client = nil
  end
end
