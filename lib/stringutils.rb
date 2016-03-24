module Stringutils
  
  # Given a normal String, convert it to an HTML-friendly format.
  # @param str The string we're converting.
  # @param email If true, we assume it's normal text to be rendered into an email.
  def Stringutils.to_html(str, email=true)
    str = email ? "<pre style=\"font-family:verdana; font-size:100%; font-color:#000000;\">" + str + "</pre": 
                  "<pre>" + str + "</pre>"
  end
  
  # Given a normal String in markdown like format, convert it to HTML.
  def Stringutils.markdown_to_html(str)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                      no_intra_emphasis: true, 
                                      fenced_code_blocks: true,   
                                      disable_indented_code_blocks: true,
                                      autolink: true)
    return markdown.render(str).html_safe
  end
  
  #############################################################
  #
  # Generic Functions
  #
  #############################################################
  
  # Returns true if String contains any digit.
  def Stringutils.has_digit(str)
    nums = ('0'..'9').to_a
    for num in nums
      if str.include? num
        return true
      end
    end
    
    return false
  end
  
  # Checks to see if str can be reasonably interpreted to be a time.
  # Does not take military time into account.
  def Stringutils.is_time(str)
    
    # If the time is just a string representation of an integer,
    # the below must be true.
    hour_test = Proc.new {|time|
      time = time.gsub(/[(pm)|(am)]/, '')  # Strip out am or pm.
      time_int = time.to_i
      time.length <= 2 && time_int > 0 && time_int < 13
    }
    
    minute_test = Proc.new {|time|
      time = time.gsub(/[(pm)|(am)]/, '')  # Strip out am or pm.
      time_int = time.to_i
      time.length <= 2 && time_int >= 0 && time_int <= 59
    }
    
    if str.nil?
      return false
    elsif str.include? ":"
      substr = str.split(":")
      if hour_test.call(substr[0]) && minute_test.call(substr[1])
        return true
      else
        return false
      end
    elsif hour_test.call(str)  # Assume it represents an hour
      return true
    else
      return false
    end
  end
  
  #############################################################
  #
  # Daily Messenger Specific String Functions
  #
  #############################################################
  
  # Given a string, extracts a date.
  def Stringutils.extract_date(str, start_date=nil)
    date_words = ["today", "tonight", "tomorrow", 
                  "monday", "tuesday", "wednesday", "thursday", "friday",
                  "mon", "tues", "wed", "thur", "fri"]
                  
    
  end
  
  # From a normal Daily Message, strip out the sender.
  # (This should be the last line.)
  def Stringutils.get_sender(message)
    message.split("\r\n")[-1]
  end
  
  # Strip out my date addition to the Daily Message.
  def Stringutils.get_natural_message(message)
    message.split("\r\n")[1..-1].join
  end
  
  # Get message body from Daily Message.
  def Stringutils.get_body(message)
    message = message.split("\r\n")[2..-1]
    message.join
  end
  
  # Get my date addition to the Daily Message.
  def Stringutils.get_my_date(message)
    message.split("\r\n")[0]
  end
  
  # From a normal Daily Message, strip out the title.
  # (This should be the line immediately after my date
  #  addition.)
  def Stringutils.get_title(message)
    message.split("\r\n")[0]
  end
  
  # From a normal Daily Message, strip out the title,
  # and then strip out the order number.
  def Stringutils.get_nice_title(message)
    msg = get_title(message)
    msg = msg.split(" ")
    msg.shift
    return msg.join(" ")
  end
  
  # From a Daily Message, grab date in the natural message, if possible.
  # Otherwise, default to my provided date.
  def Stringutils.get_dm_date(message)
    msg = message.downcase.gsub(/[^a-z0-9\s\/]/i, '')
    
    date_parse = Proc.new{|x| Date.parse(x)}
    contemporary_date = contemporary_date.nil? ? Rubyutils::try_return(date_parse, get_my_date(msg), ArgumentError)
                                               : contemporary_date
    
    if !contemporary_date.nil?
      possible_dates =  dm_interpret_date(get_natural_message(msg), contemporary_date, true)
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
  def Stringutils.dm_interpret_date(msg, released=Date.current.in_time_zone, unique=true)
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
  def Stringutils.dm_interpret_phrase_as_date(str, released=Date.current.in_time_zone)
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
  def Stringutils.dm_get_time(message)
    
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
  def Stringutils.dm_trim_for_time(msg)
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
      if has_digit(msg[i]) && msg[i].length < max_expected_valid_chars
        word = msg[i]
        
        # If word is of the pattern "1-2pm", we want to only catch "1"
        if word.include? "-"
          puts word
          substrings = word.split("-")
          if is_time(substrings[0]) && is_time(substrings[1])
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
  def Stringutils.dm_parse_times(trimmed_str, start_end=false, all=false)
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
end