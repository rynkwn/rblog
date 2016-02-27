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
    
    for i in 2..(words.length - 1)
      # From a cursory search, it seems as if the length of a date in natural
      # language is between 0 and 3
      phr1 = words[i-2..i].join(" ")
      phr2 = words[i-1..i].join(" ")
      phr3 = words[i]
      
      evalProc = Proc.new {|phrase| Chronic.parse(phrase, :guess => false, :now => date_of_text)}
      candidate1 = Rubyutils::try_return(evalProc, phr1, ArgumentError)
      candidate2 = Rubyutils::try_return(evalProc, phr2, ArgumentError)
      candidate3 = Rubyutils::try_return(evalProc, phr3, ArgumentError)
      
      # In reverse order, if a candidate is not nil, we assign it to last_date
      if (! candidate1.nil?)
        candidate1 = (candidate1.class == Chronic::Span) ? candidate1.begin :
                                                           candidate1
        last_date = (last_date < candidate1) ? 
                                              candidate1 :
                                              last_date
      elsif (! candidate2.nil?)
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
    return parse_latest_date(msg, Chronic.parse(get_my_date(msg)))
  end
  
end