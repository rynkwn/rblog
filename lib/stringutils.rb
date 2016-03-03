module Stringutils
  
  # Check to see how closely two strings are to each other.
  # Returns a pct representing how closely str2 is a
  # maximal substring of str1.
  #def cmp(str1, str2)
    #return 0.0
  #end
  
  # Given a normal String, convert it to an HTML-friendly format.
  # @param str The string we're converting.
  # @param email If true, we assume it's normal text to be rendered into an email.
  def Stringutils.to_html(str, email=true)
    str = email ? "<pre style=\"font-family:verdana; font-size:100%;\">" + str + "</pre": 
                  "<pre>" + str + "</pre>"
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
  
  # From a normal Daily Message, strip out the title.
  # (This should be the line immediately after my date
  #  addition.)
  def Stringutils.get_title(message)
    message.split("\r\n")[0]
  end
  
end