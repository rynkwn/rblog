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
    if(message && ! message.empty?)
      
      # These two lines of code will probably case some heartache for me
      # in the future. Be aware.
      msg = DailyMessage.new(content: message)
      msg.save
      
      # Mappings stores 
      messages = {}
      
      DailyMessage.all.each {|ms|
        messages[ms.created_at.strftime("%a, %b %d")] = ms.content.split("\r\n\r\n").reject{|line| line.include?("===")}
      }
      
      # For each service daily, we get the correct messages,
      # put them together, and then send them to the person.
      ServiceDaily.all.each {|dm|
      
        email = dm.user.email
        
        filtered_content = ""
        
        messages.each do |date, many_messages|
          filtered_content = filtered_content + grab_relevant_messages(dm.key_words, dm.sender, many_messages, date)
        end
        
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
  
  # Grabs relevant messages from an array of daily messages, formats appropriately,
  # and then returns the appropriately formatted String.
  # @param topics == Key_words
  # @param senders
  # @param messages
  # @param date
  def grab_relevant_messages(topics, senders, messages, date)
    output = "Daily Messages for " + date + "\n\n"
    
    # We need to modify the case and styling of messages to get this to work.
    messageComp = messages.map{|msg|
      msg = msg.downcase.strip
    }
    
    # Grab the senders of these messages.
    messageSenders = messageComp.map{|msg|
      msg = msg.split("\r\n")[-1]
    }
    
    messageIndices = Arrayutils::string_overlaps(messageComp, topics)
    senderIndices = Arrayutils::string_overlaps(messageSenders, senders)
    
    indices = messageIndices.concat(senderIndices).uniq
    content = Arrayutils::values_at(messages, indices).join("\n\n")
    content = content + "\n\n"
    
    output = output + content
    return output
  end
  
end
