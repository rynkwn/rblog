module DailyMessengerUtils
  
  
  # Try to get the antiwords associated with a key.
  # Antiwords are deal breakers when we filter for this key.
  # @param 
  # @return if antiwords are associated with that key, return it. Else
  # return nil.
  def DailyMessengerUtils.get_antiwords(key)
    DAILY_MESSENGER_ANTI_KEYWORDS.fetch(topic, nil)
  end
end