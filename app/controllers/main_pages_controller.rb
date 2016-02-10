class MainPagesController < ApplicationController
  require 'json'
  
  before_action :authorized?, 
                :only => [
                          :data_nuke, 
                          :data_parse, 
                          :analytics,
                          :analytics_send_data,
                          :daily_messenger_send
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
      
      Bloghistory::standard('DATA DUMP - ' + Time.now.to_s, data).deliver
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
  
  # Sends out daily messenger emails.
  def daily_messenger_send
    message = params[:dailymessage]
    
    # If there's a daily message to send.
    if(! message.empty?)
      
      # These two lines of code will probably case some heartache for me
      # in the future. Be aware.
      msg = DailyMessage.new(content: message)
      msg.save
      
      # Mappings stores 
      #messages = {}
      #mappings = {}
      
      #DailyMessage.all.each {|ms|
        #messages[ms.created_at.strftime("%d-%m-%Y")] = ms.content.split("\r\n\r\n").reject{|line| line.include?("===")}
      #}
      
      # Okay, now we parse the daily messages 
      # messageOrig splits by message.
      messageOrig = message.split("\r\n\r\n").reject{|line| line.include?("===")}
      
      messageMatch = messageOrig.map{|x|
        x = x.downcase
        x = x.strip
      }
      messageSenders = messageOrig.map{|x| 
        x = x.split("\r\n")[-1]
        x = x.downcase
        x = x.strip
      }
      
      # For each service daily, we get the correct messages,
      # put them together, and then send them to the person.
      ServiceDaily.all.each {|dm|
      
        email = dm.user.email
        
        # We want to store indices to keep track of which messages we're
        # interested in.
        selected_messages = []
        counter = 0
        messageMatch.each do |bodytext|
          
          dm.key_words.each do |word|
            if bodytext.include? word
              selected_messages << counter
              break
            end
          end
          
          counter = counter + 1
        end
        
        counter = 0
        messageSenders.each do |sendertext|
          
          dm.sender.each do |word|
            if sendertext.include? word
              selected_messages << counter
              break
            end
          end
          
          counter = counter + 1
        end
        
        selected_messages = selected_messages.uniq
        filtered_content = Arrayutils::values_at(messageOrig, selected_messages).join("\n\n")
        
        ServiceMailer::daily_messenger(email, filtered_content).deliver
      }
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
