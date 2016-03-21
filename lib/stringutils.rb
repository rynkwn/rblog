module Stringutils
  
  #############################################################
  #
  # Daily Messenger Specific String Functions
  #
  #############################################################
  
  # From a normal Daily Message, strip out the sender.
  # (This should be the last line.)
  def Stringutils.get_sender(message)
    message.split("\r\n")[-1]
  end
  
  # Strip out my date addition to the Daily Message.
  def Stringutils.get_natural_message(message)
    message.split("\r\n")[1..-1].join
  end
  
  # Get my date addition to the Daily Message.
  def Stringutils.get_my_date(message)
    message.split("\r\n")[0]
  end
  
  # From a normal Daily Message, strip out the title.
  # (This should be the line immediately after my date
  #  addition.)
  def Stringutils.get_title(message)
    message.split("\r\n")[1]
  end
  
  # From a Daily Message, grab date in the natural message, if possible.
  # Otherwise, default to my provided date.
  def Stringutils.get_dm_date(message)
    msg = message.downcase.gsub(/[^a-z0-9\s\/]/i, '')
    
    date_parse = Proc.new{|x| Date.parse(x)}
    contemporary_date = Rubyutils::try_return(date_parse, get_my_date(msg), ArgumentError)
    
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
  
  # Gets an array of possible dates for a message, and then returns one
  # if reasonable.
  # @param released is the date the message was initially sent out.
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
        
        if month > 0 && month <= 12
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
  
  # Looks at str and tries to determine if it's a time.
  #def dm_get_time(str)
    # Cases to handle.
    # 1:10
    # 6 PM
    # 1:10-2:00 pm
    # 6-7pm
    # 1-1:45 pm
    # 8 p.m.
    
  #  str = str.downcase.gsub(/[^a-z0-9\s]/i, '')
  #  str.split(" ")
  #end
  
end