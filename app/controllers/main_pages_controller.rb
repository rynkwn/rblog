class MainPagesController < ApplicationController
  require 'json'
  
  before_action :authorized?, 
                :only => [
                          :data_nuke, 
                          :data_parse, 
                          :analytics,
                          :analytics_send_data,
                          :daily_messenger_send,
                          :daily_messenger_announcement
                         ]
  
  #############################################################
  #
  # Data emailing related functions.
  #
  #############################################################

  # Compiles relevant data using the to_data function of models
  # and emails that data to my primary email address.
  def data_nuke
    if ryan?
      data = ""
      
      # Dumping the relevant data.
      Subject.all.each do |subject|
        data = data + subject.to_json + "ʭ"
      end
      Blog.all.each do |blog|
        data = data + blog.to_json + "ʭ"
      end
      
      Bloghistory::standard('DATA DUMP - ' + Time.current.in_time_zone.to_s, data).deliver
      flash.now[:success] = "Data nuke launched!"
    else
      flash.now[:danger] = "Incorrect Authorization Level, Repriming coordinates " +
                           "of data nuke."
    end
  end
  
  # Parses a data nuke and adds the embedded objects to the database.
  def data_parse
    data = params[:data]
    if !data.nil?
      data.split("ʭ").each do |dat|
        create_from_json(JSON.parse(dat))
      end
    end
  end
  
  
  #############################################################
  #
  # Analytics related functions
  #
  #############################################################
  
  # Iterates over the Hits database and returns a hash of page descriptions to
  # hit count. More options planned.
  def analytics
    @data_tables = ['Users', 'Hits']
    
    if params[:commit]
      if params[:table] == 'Hits'
        @summary = summarize_hits
        @summary['Total'] = @summary.values.inject {|sum, n| sum + n}
      elsif params[:table] == 'Users'
        @summary = summarize_users
        @summary['Total'] = @summary.values.count
      end
    else
      @summary = summarize_hits
    end
    
  end
  
  # We create a JSON object to email to a third party data storage system.
  # This JSON object contains the range of dates as well as the meta data.
  def analytics_send_data
    if(Hit.count > 0)
      # Assume that the first and last objects correspond to
      # first and last hits made.
      first_date = Hit.first.as_json['date_created'].strftime("%d-%m-%Y")
      last_date = Hit.last.as_json['date_created'].strftime("%d-%m-%Y")
      
      summary_data = {
                      start_date: first_date,
                      end_date: last_date,
                      hits: summarize_hits
                      }
                      
      Bloghistory::analytics_email(
                                   first_date, 
                                   last_date, 
                                   summary_data
                                   ).deliver
      Hit.delete_all
      redirect_to(analytics_path)
    else
      flash.now[:danger] = "No analytics data to send."
    end
  end
  
  #############################################################
  #
  # Daily Messenger related functions
  #
  #############################################################
  
  # Sends out daily messenger emails
  def daily_messenger_send
    message = params[:dailymessage]
    
    # If there's a daily message to send.
    if(message && ! message.empty?)
      
      mymessage = ""
      if(params[:mymessage] && ! params[:mymessage].empty?)
        mymessage =       "----------------------------------------------------" + "\n" +
                          "\t" + "Message from Ryan" + "\n" +
                          "----------------------------------------------------" + "\n"
        mymessage = mymessage + params[:mymessage]
      end
      
      # These two lines of code will probably case some heartache for me
      # in the future. Be aware.
      msg = DailyMessage.new(content: message)
      msg.save
      
      # Messages stores the original messages (with my date modification)
      # Tempmessages will be used for filtering and comparison of message bodies.
      # Senders will be used for comparison.
      messages = []
      tempmessages = []
      senders = []
      
      DailyMessage.all.reverse.each {|ms|
        days_messages = ms.content.split("\r\n\r\n").reject{|line| line.include?("===")}
        date_created = ms.created_at.in_time_zone.strftime("%a, %b %d")
        
        temp_days_messages = days_messages.map{|x| x = x.downcase.strip}
        tempmessages = tempmessages.concat(temp_days_messages)
        
        days_messages = days_messages.map {|x| x = date_created + "\n" + x }
        days_senders = days_messages.map {|x| x = x.split("\r\n")[-1] }
        
        messages = messages.concat(days_messages)
        senders = senders.concat(days_senders)
      }
      
      # Downcased messages and senders.
      messagesComp = tempmessages
      senders = senders.map{|x| x = x.downcase.strip}
      
      # TODO: Increase robustness. Currently useless.
      # Check for repeated messages and remove them.
      #redundant_indices = Arrayutils::redundant_indices(messagesComp)
      #messagesComp = Arrayutils::delete_at(messagesComp, redundant_indices)
      #senders = Arrayutils::delete_at(senders, redundant_indices)
      
      # mappings will store integers to reference which messages satisfy 
      # a key_word or sender choice.
      mappings = {}
      
      DAILY_MESSENGER_KEYWORDS.each do |topic, keywords|
        mappings[topic] = Arrayutils::string_overlaps(messagesComp, keywords.split(","))
      end
      
      DAILY_MESSENGER_SENDERS.each do |sender, sender_words|
        mappings[sender] = Arrayutils::string_overlaps(senders, sender_words.split(","))
      end
      
      # For each service daily, we get the correct messages,
      # put them together, and then send them to the person.
      ServiceDaily.all.each {|dm|
      
        email = dm.user.email
        dm_keys = dm.key_words.concat(dm.sender)
        
        filtered_content = mymessage.empty? ? "" : mymessage + "\n\n"
        
        dm_keys.each do |key|
          content_header = "\n\n\n" +
                          "----------------------------------------------------" + "\n" +
                          "\t" + key + "\n" +
                          "----------------------------------------------------" + "\n"
          
          content = Arrayutils.values_at(messages, mappings[key]).join("\n\n")
          
          if(! content.empty?)
            filtered_content = filtered_content + content_header + content
          end
          
        end
        
        
        # Assume that Daily Messenger is empty.
        subject = "Daily Messenger: Nothing Interested Going on Right Now!"
        
        if !filtered_content.empty?
          header = "----------------------------------------------------" + "\n" +
                   "Change preferences at https://arg.press/my_daily_messenger" + "\n" +
                   "----------------------------------------------------"
          
          filtered_content = header + filtered_content
          
          subject = 'Your Daily Messenger for ' + Date.current.in_time_zone.strftime("%a, %b %d")
        end
        
        ServiceMailer::daily_messenger(email, subject, filtered_content).deliver
      }
    end
  end
  
  # Send announcement email to Daily Messenger Users.
  def daily_messenger_announcement
    subject = params[:subject]
    message = params[:message]
    
    if(subject && !subject.empty? && message && !message.empty?)
      ServiceDaily.all.each do |dm|
        user = dm.user
        ServiceMailer::email(subject, user.email, message).deliver
      end
    end
  end

  private
  
  # Daily Messenger Params
  def daily_message_params
    params.require(:daily_message).permit(:content)
  end
  
  # Summarize hit data.
  def summarize_hits
    summary = Hash.new(0)
    Hit.all.each {|hit| summary[hit.page] += 1}
    return summary
  end
  
  def summarize_users
    summary = Hash.new('')
    User.all.each {|user| summary[user.email] = user.email}
    return summary
  end
  
  
end
