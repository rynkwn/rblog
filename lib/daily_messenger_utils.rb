module DailyMessengerUtils
  
  # Try to get the keywords associated with a key.
  # @param key The key associated with the keywords
  # @return if keywords are associated with that key, return it. Else
  # return nil.
  def DailyMessengerUtils.get_keywords(key)
    DAILY_MESSENGER_KEYWORDS.fetch(key, nil)
  end
  
  # Try to get the senders associated with a key.
  # @param key The key associated with the sender information
  # @return if sender are associated with that key, return it. Else
  # return nil.
  def DailyMessengerUtils.get_senders(key)
    DAILY_MESSENGER_SENDERS.fetch(key, nil)
  end
  
  # Try to get the antiwords associated with a key.
  # Antiwords are deal breakers when we filter for this key.
  # @param key The key associated with the antiwords.
  # @return if antiwords are associated with that key, return it. Else
  # return nil.
  def DailyMessengerUtils.get_antiwords(key)
    DAILY_MESSENGER_ANTI_KEYWORDS.fetch(key, nil)
  end
  
  # Try to get the category information associated with a key.
  # @param key The key associated with the keywords
  # @return if category information is associated with that key, return it. Else
  # return nil.
  def DailyMessengerUtils.get_category(key)
    DAILY_MESSENGER_CATEGORY_MAPS.fetch(key, nil)
  end
  
  #############################################################
  #
  # String Functions
  #
  #############################################################
  
  # From a normal Daily Message, strip out the sender.
  # (This should be the last line.)
  def DailyMessengerUtils.get_sender(message)
    message.split("\r\n")[-1]
  end
  
  # Strip out my date addition to the Daily Message.
  def DailyMessengerUtils.get_natural_message(message)
    message.split("\r\n")[1..-1].join
  end
  
  # Get message body from Daily Message.
  def DailyMessengerUtils.get_body(message)
    message = message.split("\r\n")[2..-1]
    message.join
  end
  
  # Get my date addition to the Daily Message.
  def DailyMessengerUtils.get_my_date(message)
    message.split("\r\n")[0]
  end
  
  # From a normal Daily Message, strip out the title.
  # (This should be the line immediately after my date
  #  addition.)
  def DailyMessengerUtils.get_title(message)
    message.split("\r\n")[0]
  end
  
  # From a normal Daily Message, strip out the title,
  # and then strip out the order number.
  def DailyMessengerUtils.get_nice_title(message)
    msg = get_title(message)
    msg = msg.split(" ")
    msg.shift
    return msg.join(" ")
  end
  
  # Same as filter above, but an extra step is done to
  # only compare the sender of the message.
  def DailyMessengerUtils.filter_sender(messages, filters)
    filtered = []
    
    filtered = messages.select{|msg|
      contains_string(get_sender(msg), filters)
    }
    
    return filtered
  end
  
  # Build up a String array from messages that
  # contain at least one member of filters.
  # @param messages Is the space we're filtering over.
  # @param filters An array of key_words we're filtering for.
  # @param antifilters An array of key_words that would cause us to reject a message.
  def DailyMessengerUtils.filter(messages, filters, antifilters=nil)
    filtered = []
    
    if filters.any?
      filtered = messages.select{|msg|
        contains_string(msg, filters) && !contains_string(msg, antifilters)
      }
    else
      filtered = messages.reject{|msg|
        contains_string(msg, antifilters)
      }
    end
    
    return filtered
  end
  
  # Figure out if a body of text contains at least one element of a String array
  # efficiently
  # @param bodytext. We downcase it in the function.
  # @param array is the String array which we're comparing on bodytext.
  # We assume each word in array is downcased. Array may be nil.
  def DailyMessengerUtils.contains_string(bodytext, array)
    if array.any?
      array.each do |word|
        if(bodytext.downcase.include? word)
          return true
        end
      end
    end
    
    return false
  end
  
  # Creates a hash where each key is the topic/heading selected, and the values
  # are the filtered messages.
  # @param categorized_messages A hash matching categories to daily messages.
  # @param dm The user's Daily Messenger settings.
  def DailyMessengerUtils.adv_filter(categorized_messages, dm)
    dm_keys = dm.adv_keys
    filtered_messages = {}
    
    dm_keys.each do |key|
      keywords = dm.adv_keywords[key].split(",")
      antiwords = dm.adv_antiwords[key].split(",")
      senders = dm.adv_senders[key].split(",")
      categories = dm.adv_categories[key].split(",")  # "" or valid.
      categories = categories.any? ? categories : ["all"]
      
      # TODO: For each category, we concat the unique messages to our list of
      # messages.
      messages = aggregate_categorized_messages(categorized_messages, categories)

      # Now we check each sender, and we keep the ones that contain the sender.
      if senders.any?
        messages = filter_sender(messages, senders)
      end
      
      filtered_messages[key] = filter(messages, keywords, antiwords)
    end
    
    return filtered_messages
  end
  
  # Aggregate all messages in the selected categories from a hash of categorized messages. 
  def DailyMessengerUtils.aggregate_categorized_messages(categorized_messages, categories)
    messages = []
    categories.each do |cat|
      messages.concat(categorized_messages[cat])
    end
    
    return messages
  end
  
  # @param daily_messages A hash of the normal daily messages.
  # @param messages_to_remove An array of all messages we want to remove.
  def DailyMessengerUtils.anti_filter(daily_messages, messages_to_remove)
    filtered_messages = {}
    
    daily_messages.each {|key, values|
      filtered_messages[key] = values - messages_to_remove
    }
    
    return filtered_messages
  end
  
  #############################################################
  #
  # Time and Date Functionality.
  #
  #############################################################
  
  # From a Daily Message, grab date in the natural message, if possible.
  # Otherwise, default to my provided date.
  def DailyMessengerUtils.get_dm_date(message, contemporary_date)
    msg = message.downcase.gsub(/[^a-z0-9\s\/]/i, '')
    
    date_parse = Proc.new{|x| Date.parse(x)}
    contemporary_date = contemporary_date.nil? ? Rubyutils::try_return(date_parse, get_my_date(msg), ArgumentError)
                                               : contemporary_date
    
    if !contemporary_date.nil?
      possible_dates =  dm_interpret_date(msg, contemporary_date, true)
      last_mentioned_date = possible_dates.last
      if(last_mentioned_date.nil?)
        return contemporary_date
      else
        return last_mentioned_date
      end
    end
    
    # We return this iff it's not a normally formatted message. In which case
    # it's most likely a category. I.e., === SOMETHING ===
    return []
  end
  
  # Gets an array of possible dates for a message
  # @param released is the date the message was initially sent out.
  # @param unique is a flag that signals whether we want to return unique dates only
  def DailyMessengerUtils.dm_interpret_date(msg, released=Date.current.in_time_zone, unique=true)
    possible_dates = []
    msg = msg.split(" ").map{|x| x.strip}
    for i in 1..(msg.length - 1)
      proposed_date_1 = dm_interpret_phrase_as_date(msg[(i-1)..i], released)
      proposed_date_2 = dm_interpret_phrase_as_date([msg[i]], released)
      
      if !proposed_date_1.nil?
        possible_dates << proposed_date_1
      end
      
      if !proposed_date_2.nil?
        possible_dates << proposed_date_2
      end
    end
    
    if unique
      possible_dates = possible_dates.uniq
    end
    
    return possible_dates
  end
  
  # Looks at a small phrase and tries to see if it refers to a date. If it is a date
  # we return the appropriate date, formatted.
  # otherwise we 
  # We assume the string is downcased, stripped of any punctuation, and in an array
  # split by spaces.
  # @param str is an array containing 1-2 strings.
  # @param released is the date the message was initially sent out.
  def DailyMessengerUtils.dm_interpret_phrase_as_date(str, released=Date.current.in_time_zone)
    if str.size == 1
      # If the string is size 1, we assume it refers to a day of the week, or
      # something of the form XX/XX
      days = ['mon', 'tue', 'wed', 'thur', 'fri', 'sat', 'sun',
              'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday',
              'sunday',
              'tues']
      relative_days = ['today', 'tomorrow', 'tonight']
      str = str[0]  # We need to unwrap the singleton array.
      if days.include? str
        proposed_date = Date.parse(str)
        tentative_day = proposed_date.day
        
        # If the tentative_day is less than the current day, we assume it takes
        # place next week.
        days_in_week = 7
        proposed_date = (tentative_day < released.day) ? proposed_date + days_in_week :
                                                         proposed_date
        
        return proposed_date
      end
      
      if relative_days.include? str
        if str == 'today' || str == 'tonight'
          return released
        else
          tomorrow = 1
          return released + tomorrow
        end
      end
      
      if str.include? '/'
        # In this case, we assume the string is of the form XX/XX
        samp = str.split('/')
        month = samp[0].to_i
        day = samp[1].to_i
        
        if month > 0 && month <= 12 && day > 0 && day <= 31
          return Date.parse(str)
        end
      end
      
    elsif str.size == 2
      # Now we assume it refers to a month day, or MON ## combination.
      month = ['jan', 'feb', 'mar', 'may', 'june', 'july', 'aug', 'sept', 'oct',
               'nov', 'dec',
               'january', 'february', 'march', 'april', 'august', 'september',
               'october', 'november', 'december']
      day = [('1'..'31').to_a, 
             '1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th', '9th', '10th',
             '11th', '12th', '13th', '14th', '15th', '16th', '17th', '18th',
             '19th', '20th', '21st', '22nd', '23rd','24th', '25th', '26th',
             '27th', '28th', '29th', '30th', '31st'].flatten
      
      if month.include?(str[0]) && day.include?(str[1])
        return Date.parse(str.join(" "))
      end
    end
    
    return nil
  end
  
  # For a given message, return what time (or range of times) the message refers to.
  # @param message a daily message.
  def DailyMessengerUtils.dm_get_time(message)
    
    if !message.include? "==="
      #msg = get_body(message)
      msg = message.downcase.gsub(/[^a-z0-9\s\/:-]/i, '')
      msg = msg.split("-").map{|x| x.strip}.join("-")  # Cleans up instances like '11 -12'
      
      msg = dm_trim_for_time(msg)
      return dm_parse_times(msg, true)
    end
    
    # We return this if it's a category, which we determine by the presence of "==="
    return []
  end
  
  # For a given message, remove all words that either do not contain a number,
  # or are not preceded by a number.
  # @return An array of words that satisfy the above conditions.
  def DailyMessengerUtils.dm_trim_for_time(msg)
    msg = msg.split(" ")
    
    words_of_interest = []
    max_expected_valid_chars = 14  # Ex: 12:20-12:45pm
    
    # Try to get the hour from some String, and convert to int.
    # We assume that it makes sense whenever we do this.
    determine_hour = Proc.new {|time|
      if time.include? ":"
        time.split(":")[0].to_i  # With a format like 2:20, get the first half.
      else
        time.to_i
      end
    }
    
    # Determine whether a time should be PM or AM.
    determine_suffix = Proc.new {|time|
      if (time.include? "am") || (time.include? "pm")
        time
      else
        guessed_hour = determine_hour.call(time)
        if guessed_hour <= 9 || guessed_hour == 12
          # At certain hours, we can usually assume it takes place in the
          # afternoon or evening.
          time + "pm"
        elsif guessed_hour <= 12  # Should be a non-military hour.
          time + "am"
        else
          time
        end
      end
    }
    
    for i in 1..(msg.length - 1)
      if Stringutils::has_digit(msg[i]) && msg[i].length < max_expected_valid_chars
        word = msg[i]
        
        # If word is of the pattern "1-2pm", we want to only catch "1"
        if word.include? "-"
          puts word
          substrings = word.split("-")
          if Stringutils::is_time(substrings[0]) && Stringutils::is_time(substrings[1])
            word = substrings[0]
            words_of_interest << determine_suffix.call(substrings[1])
          end
        end
        
        word = determine_suffix.call(word)
        words_of_interest << word
        
        if i < msg.length - 1
          words_of_interest << (word + " " + msg[i+1])
        end
      end
    end
    
    return words_of_interest
  end
  
  
  # Looks at str and tries to determine if it's a time.
  # Cases to handle:
  # 1:10
  # 6 PM
  # 1:10-2:00 pm
  # 6-7pm
  # 1-1:45 pm
  # 8 p.m.
  # 12:20-12:45pm
  # @param trimmed_str A trimmed array of words.
  # @param start_end If true, returns a start and end time if reasonably certain.
  # In practice, we check to see if we find only two times.
  # @param all If true, return all filtered times.
  # @return An array of Time objects.
  def DailyMessengerUtils.dm_parse_times(trimmed_str, start_end=false, all=false)
    times = trimmed_str.map{|time|
      begin
        Time.parse(time, Time.current.in_time_zone.midnight())
      rescue ArgumentError  # Usually "argument out of range" or "no time information"
      end
    }
    
    times = times.reject{|time| time.nil? || Date.current > time || (Date.current + 1) < time }
    times = times.uniq
    times = times.sort
    if start_end && times.size == 2
        return times
    end
    
    times = all ? times : [times[0]]
    return times
  end
    
    
  #  str = str.downcase.gsub(/[^a-z0-9\s]/i, '')
  #  str.split(" ")
  #end
  
  #############################################################
  #
  # Formatting and Aesthetic Functions
  #
  #############################################################
  
  # For a given key and its associated messages, return a HTML-formatted preview.
  # @param key Used as a heading for the preview.
  # @messages All messages associated with the key.
  def DailyMessengerUtils.preview(key, messages)
    preview = ""
    
    content_header = "\t=== " + key + " ===\r\n"
    content = messages.map{|x| get_title(x)}.join("\n")
    
    if(! content.empty?)
      preview = preview + Stringutils::to_html(content_header + content + "\r\n\r\n")
    end
    
    return preview
  end
  
  # Generate Daily Messenger body given a key and its associated messages.
  # @param key Used as a heading for the content.
  # @messages All messages associatd with the key.
  def DailyMessengerUtils.body(key, messages)
    body = ""
    content_header = "\n\n\n" +
                        "----------------------------------------------------" + "\n" +
                        "\t" + key + "\n" +
                        "----------------------------------------------------" + "\n"
    content = messages
    content = content.map{|msg|
      # We need to do a lot of cleaning to make sure the title allows for a
      # valid link.
      title = get_nice_title(msg)
      title = title.gsub("\"", "'").gsub("&", 'and').gsub(/[^A-Za-z0-9\s-]/i, ' ')
      #msg + "\r\n\t" + generate_calendar_link(title, Stringutils::get_dm_date(msg, Date.current.in_time_zone))
      date = get_dm_date(msg, Date.current.in_time_zone)
      times = dm_get_time(msg)
      if times.size == 1
        msg = msg + "\r\n\t" + generate_calendar_link(title, date, times[0])
      elsif times.size == 2
        msg = msg + "\r\n\t" + generate_calendar_link(title, date, times[0], times[1])
      else
        msg = msg + "\r\n\t" + generate_calendar_link(title, date)
      end
      msg
    }
    content = content.join("\n\n")
    
    if(! content.empty?)
      body = body + Stringutils::to_html(content_header + content)
    end
    
    return body
  end
  
  # Given a category, surround it with "==="
  def DailyMessengerUtils.format_category(category)
    "=== " + category + " ==="
  end
  
  # Given a category formatted like '=== STUFF ==='
  # return 'STUFF'
  def DailyMessengerUtils.unbox_category(category)
    cat = category.gsub("===", '').strip
    return cat
  end
  
  #############################################################
  # Add-to-Calendar functions.
  #############################################################
  
  # Generates the URL + button to create a google calendar event.
  def DailyMessengerUtils.generate_calendar_link(title, date=DateTime.current.in_time_zone, start_t=nil, end_t=nil, location=nil)
    base_url = "https://calendar.google.com/calendar/render?action=TEMPLATE"
    title_add = title ? "&text=" + title : ""
    date_add = "&dates=" + generate_calendar_datetime(date, start_t, end_t)
    location_add = location ? "&location=" + location : ""
    
    final_url = base_url + title_add + date_add + location_add
    
    button_text = "Add to Calendar!"
    button_code = '<table cellspacing="0" cellpadding="0">' +
                  '<tr>' +
                  '<td align="center" width="130" height="20" bgcolor="#449D44" style="-webkit-border-radius: 5px; -moz-border-radius: 5px; border-radius: 5px; color: #ffffff; display: block;">' +
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
  # @param start_time The start time of the event. We make do if not available.
  # @param end_time The end time of the event. Only valid if we have the start time.
  def DailyMessengerUtils.generate_calendar_datetime(date=Date.current.in_time_zone, start_time=nil, end_time=nil)
    start_date = date.strftime("%Y%m%d")
    current_date = Date.current.in_time_zone
    
    seconds_in_day = 86400
    seconds_in_half_hour = 1800
    
    end_date = date == current_date ? (date + seconds_in_day).strftime("%Y%m%d") :
                                      (date + 1).strftime("%Y%m%d")
    
    if start_time
      start_date = start_date + "T" + start_time.strftime("%H%M%S")
      end_date = end_time ? date.strftime("%Y%m%d") + "T" + end_time.strftime("%H%M%S") :
                            date.strftime("%Y%m%d") + "T" + (start_time + seconds_in_half_hour).strftime("%H%M%S")
    end
    
    return start_date + '/' + end_date
  end
end