module Stringutils
  require 'chronic'
  
  # Check to see how closely two strings are to each other.
  # Returns a pct representing how closely str2 is a
  # maximal substring of str1.
  #def cmp(str1, str2)
    #return 0.0
  #end
  
  # From a body of text, return the mentioned date that's furthest in the
  # future.
  # @param text The body of text for which we want to find the last date.
  # @param date_of_text Is the date the text was relevant. 
  def Stringutils.parse_latest_date(text, date_of_text)
    last_date = date_of_text
    words = text.split(" ")
    
    for i in 1..(words.length - 1)
      # From a cursory search, it seems as if the length of a date in natural
      # language is between 0 and 3
      phr2 = words[i-1..i].join(" ")
      phr3 = words[i]
      
      evalProc = Proc.new {|phrase| Chronic.parse(phrase, :guess => false, :now => date_of_text)}
      candidate2 = Rubyutils::try_return(evalProc, phr2, ArgumentError)
      candidate3 = Rubyutils::try_return(evalProc, phr3, ArgumentError)
      
      # In reverse order, if a candidate is not nil, we assign it to last_date
      if (! candidate2.nil?)
        candidate2 = (candidate2.class == Chronic::Span) ? candidate2.begin :
                                                           candidate2
        last_date = (last_date < candidate2) ? 
                                              candidate2 :
                                              last_date
      
      elsif(! candidate3.nil?)
        candidate3 = (candidate3.class == Chronic::Span) ? candidate3.begin :
                                                           candidate3
        last_date = (last_date < candidate3) ? 
                                              candidate3 :
                                              last_date
      end
    end
    
    return last_date
  end
  
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
    msg = message.downcase.gsub(/[^a-z0-9\s]/i, '')
    contemporary_date = Chronic.parse(get_my_date(msg))
    #date = parse_latest_date(get_title(msg), contemporary_date)
    #if date != contemporary_date
    #  return date
    #end
    
    return parse_latest_date(msg, Chronic.parse(get_my_date(msg)))
  end
  
  def Stringutils.dm_date_def(msg)
    
  end
  
  # Looks at str and tries to see if it refers to a date. If it is a date
  # we return the appropriate date, formatted.
  # otherwise we 
  # We automatically downcase the string and strip out any punctuation.
  # @param str is a 1-2 word String.
  # @param released is the date the message was initially sent out.
  def dm_get_date?(str, released=Date.current.in_time_zone)
    str = str.downcase.gsub(/[^a-z0-9\s]/i, ' ')
    str = str.split(" ").map{|x| x.strip}
    
    if str.size == 1
      # If the string is size 1, we assume it refers to a day of the week.
      days = ['mon', 'tue', 'wed', 'thur', 'fri', 'sat', 'sun',
              'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday',
              'sunday',
              'tues']
      relative_days = ['today', 'tomorrow', 'tonight']
      if days.include? str
        proposed_date = Date.parse(str)
        tentative_day = proposed_date.day
        current_day = released.day
        
        # If the tentative_day is less than the current day, we assume it takes
        # place next week.
        num_sec_in_week = 604800
        proposed_date = (tentative_day < current_day) ? proposed_date + num_sec_in_week :
                                                        proposed_date
        
        return proposed_date
      end
      
      if relative_days.include? str
        if str == 'today' || str == 'tonight'
          return released
        else
          num_sec_in_days = 86400
          return released + num_sec_in_days
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
             '11th', '12th', '13th'].flatten
      
      return month.include?(str[0]) && day.include?(str[1])
    end
  end
  
  # Looks at str and tries to determine if it's a time.
  def dm_is_time(str)
    # Cases to handle.
    # 1:10
    # 6 PM
    # 1:10-2:00 pm
    # 6-7pm
    # 1-1:45 pm
    # 8 p.m.
    
    str = str.downcase.gsub(/[^a-z0-9\s]/i, '')
    str.split(" ")
  end
  
end