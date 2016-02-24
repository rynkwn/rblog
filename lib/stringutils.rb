module Stringutils
  
  # Check to see how closely two strings are to each other.
  # Returns a pct representing how closely str2 is a
  # maximal substring of str1.
  #def cmp(str1, str2)
    #return 0.0
  #end
  
  #############################################################
  #
  # Daily Messenger Specific String Functions
  #
  #############################################################
  
  # From a normal Daily Message, strip out the sender.
  def Stringutils.get_sender(message)
    message.split("\r\n")[-1]
  end
  
end