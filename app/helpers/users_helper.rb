module UsersHelper
  
  #############################################################
  #
  # Daily Messenger related functions
  #
  #############################################################
  
  # If the user is an advanced user, get the keywords specified by the user.
  # Key may be associated with either DAILY_MESSENGER_KEYWORDS or
  # DAILY_MESSENGER_SENDERS.
  # @param key The key associated with the keywords
  def grab_keyword_or_sender_values(key)
    if @dm.advanced?
      value = @dm.adv_keywords[key].gsub(',', ', ')
    else
      val1 = DAILY_MESSENGER_KEYWORDS[key]
      val2 = DAILY_MESSENGER_SENDERS[key]
      if val1
        value = val1.gsub(',', ', ')
      else
        value = val2.gsub(',', ', ')
      end
    end
    return value
  end
  
  # If the user is an advanced user, grab their specified antiword values.
  # Antiwords are words that are deal-breakers when we filter.
  # @param key The key associated with the antiwords
  # @return The antiwords, or an empty String if none exist.
  def grab_antiword_values(key)
    antiwords = DailyMessengerUtils.get_antiwords(key)
    if antiwords
      return antiwords.gsub(',', ', ')
    else
      return ""
    end
  end
end
