class MainPagesController < ApplicationController
  require 'json'
  
  before_action :authorized?, 
                :only => [
                          :data_nuke, 
                          :data_parse, 
                          :analytics,
                          :analytics_send_data,
                          :daily_messenger_send,
                          :daily_messenger_announcement,
                          :daily_messenger_keyword_change
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
    @data_tables = ['Users', 'Hits', 'Daily Messenger']
    
    if params[:commit]
      if params[:table] == 'Hits'
        @summary = summarize_hits
        @summary['Total'] = @summary.values.inject {|sum, n| sum + n}
      elsif params[:table] == 'Users'
        @summary = summarize_users
        @summary['Total'] = @summary.values.count
      elsif params[:table] = "Daily Messenger"
        @summary = summarize_dm
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
        mymessage =       "\n\n\n" + 
                          "----------------------------------------------------" + "\n" +
                          "\t" + "Message from Ryan" + "\n" +
                          "----------------------------------------------------" + "\n"
        mymessage = mymessage + params[:mymessage]
      end
      
      # These two lines of code will probably case some heartache for me
      # in the future. Be aware.
      msg = DailyMessage.new(content: message)
      msg.save
      
      # Messages stores the original messages (with my date modification)
      messages = []
      
      #DailyMessage.all.reverse.each {|ms|
      #  date_created = ms.created_at.in_time_zone.strftime("%a, %b %d")
      #  days_messages = ms.content.split("\r\n\r\n").map do |x|
      #    x = (!x.include? "===") ? date_created + "\r\n" + x :
      #                              x
      #  end
        
      #  messages = messages.concat(days_messages)
      #}
      
      days_messages = DailyMessage.last.content.split("\r\n\r\n")
      
      messages = messages.concat(days_messages)
      
      # Now I want to organize messages by category.
      category_test = Proc.new {|x| x.include?("===")}
      ms_categorized = Arrayutils::group(messages, category_test, true, true)
      ms_categorized["all"] = messages.reject{|ms| ms.include?("===")}
      
      # TODO: Increase robustness. Currently useless.
      # Check for repeated messages and remove them.
      #redundant_indices = Arrayutils::redundant_indices(messagesComp)
      #messagesComp = Arrayutils::delete_at(messagesComp, redundant_indices)
      #senders = Arrayutils::delete_at(senders, redundant_indices)
      
      # mappings will store integers to reference which messages satisfy 
      # a key_word or sender choice.
      mappings = {}
      
      DAILY_MESSENGER_KEYWORDS.each do |topic, keywords|
        category = DAILY_MESSENGER_CATEGORY_MAPS.fetch(topic, "all")
        ms_map = ms_categorized[category]
        mappings[topic] = Arrayutils::filter(ms_map, keywords.split(","))
      end
      
      DAILY_MESSENGER_SENDERS.each do |sender, sender_words|
        mappings[sender] = Arrayutils::filter_sender(ms_categorized["all"], sender_words.split(","))
      end
      
      # For each service daily, we get the correct messages,
      # put them together, and then send them to the person.
      ServiceDaily.all.each {|dm|
      
        email = dm.user.email
        dm_keys = dm.key_words.concat(dm.sender)
        
        filtered_content = mymessage.empty? ? "\r\n" : mymessage + "\r\n\r\n"
        filtered_content = Stringutils::to_html(filtered_content)
        
        # Populate the DM with content.
        filtered_content = filtered_content + dm_preview(dm_keys, mappings)
        filtered_content = filtered_content + dm_body(dm_keys, mappings)
        
        # Assume that Daily Messenger is empty.
        subject = filtered_content.blank? ? "Daily Messenger: Nothing Interesting Going On" :
                                            'Your Daily Messenger for ' + Date.current.in_time_zone.strftime("%a, %b %d")
        
        header = "----------------------------------------------------" + "\n" +
                 "Change preferences at http://www.arg.press/my_daily_messenger" + "\n" +
                 "----------------------------------------------------"
        header = Stringutils::to_html(header)
        
        filtered_content = header + filtered_content
        
        ServiceMailer::daily_messenger(email, subject, filtered_content).deliver
      }
    end
  end
  
  # Send announcement email to Daily Messenger Users.
  def daily_messenger_announcement
    subject = params[:subject]
    message = params[:message]
    
    if(subject && !subject.empty? && message && !message.empty?)
      message = Stringutils::to_html(message)
      ServiceDaily.all.each do |dm|
        user = dm.user
        ServiceMailer::email(subject, user.email, message).deliver
      end
    end
  end
  
  # Use to convert users by changing all instances of @from to @to in their
  # ServiceDaily keywords.
  def daily_messenger_keyword_change
    from = params[:from]
    to = params[:to]
    if(from && !from.empty? && to && !to.empty?)
      ServiceDaily.all.each do |dm|
        dm.key_words = Arrayutils::replace(dm.key_words, from, to)
        dm.save
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
  
  def summarize_dm
    summary = Hash.new(0)
    ServiceDaily.all.each do |dm|
      dm.key_words.each {|keyword| summary[keyword] += 1}
      dm.sender.each {|sender| summary[sender] += 1}
    end
    return summary
  end
  
  #############################################################
  #
  # Daily Messenger Private functions
  #
  #############################################################
  
  # Generate Daily Messenger Preview section given a list of keys
  # and a mapping that maps keys to daily messages.
  def dm_preview(keys, mappings)
    preview = ""
    
    keys.each do |key|
      content_header = "\t=== " + key + " ===\r\n"
      content = mappings[key].map{|x| Stringutils::get_title(x)}.join("\n")
      
      if(! content.empty?)
        preview = preview + Stringutils::to_html(content_header + content + "\r\n\r\n")
      end
    end
    
    return preview
  end
  
  # Generate Daily Messenger body given a list of keys and a mapping
  # that maps keys to daily messages.
  def dm_body(keys, mappings)
    body = ""
    
    keys.each do |key|
      content_header = "\n\n\n" +
                          "----------------------------------------------------" + "\n" +
                          "\t" + key + "\n" +
                          "----------------------------------------------------" + "\n"
      content = mappings[key]
      content = content.map{|msg|
        title = Stringutils::get_nice_title(msg).gsub("\"", "'").gsub("&", 'and')
        msg + "\r\n" + generate_calendar_link(title)
      }
      content = content.join("\n\n")
      
      if(! content.empty?)
        body = body + Stringutils::to_html(content_header + content)
      end
    end
    
    return body
  end
  
  # Generates the URL + button to create a google calendar event.
  def generate_calendar_link(title, date=DateTime.current.in_time_zone, time=nil, location=nil)
    base_url = "https://calendar.google.com/calendar/render?action=TEMPLATE"
    title_add = title ? "&text=" + title : ""
    date_add = "&dates=" + generate_calendar_datetime(date, time)
    location_add = location ? "&location=" + location : ""
    
    final_url = base_url + title_add + date_add + location_add
    
    button_text = "Add to Calendar!"
    button_code = '<table cellspacing="0" cellpadding="0">' +
                  '<tr>' +
                  '<td align="center" width="130" height="30" bgcolor="#449D44" style="-webkit-border-radius: 5px; -moz-border-radius: 5px; border-radius: 5px; color: #ffffff; display: block;">' +
                  '<a href="' + final_url +  '" style="font-size:12px; font-weight: bold; font-family: verdana; text-decoration: none; width:100%; display:inline-block">' +
                  '<span style="color: #FFFFFF">' + button_text + '</span></a>' +
                  '</td>' +
                  '</tr>' +
                  '</table>'
    
    return button_code
  end
  
  # Generates an appropriately formatted datetime string
  # for use in generate_calendar_link
  # Requires a date param.
  # @param date The date the event takes place on. We assume it ends the same day.
  # @param time If possible, the time the event takes place. If we don't have it
  # we make do.
  def generate_calendar_datetime(date, time=nil)
    start_date = date.strftime("%Y%m%d")
    end_date = (date + 1).strftime("%Y%m%d")
    
    if time
      start_date = start_date + "T" + time.strftime("%H%M")
      end_date = end_date + "T" + (time + 1).strftime("%H%M")
    end
    
    return start_date + '/' + end_date
  end
  
end
