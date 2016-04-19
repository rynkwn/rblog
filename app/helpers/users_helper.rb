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
  def grab_keywords(key)
    if @dm.advanced?
      value = @dm.adv_keywords[key]
    else
      value = DailyMessengerUtils.get_keywords(key)
      if value.nil?
        value = ""
      end
    end
    return value.gsub(',', ', ')
  end
  
  def grab_senders(key)
    if @dm.advanced?
      value = @dm.adv_senders[key]
    else
      value = DailyMessengerUtils.get_senders(key)
      if value.nil?
        value = ""
      end
    end
    return value.gsub(',', ', ')
  end
  
  def grab_category(key)
    if @dm.advanced?
      value = @dm.adv_categories[key]
    else
      value = DailyMessengerUtils.get_category(key)
      if value.nil?
        value = ""
      else
        value = DailyMessengerUtils.unbox_category(value)
      end
    end
    return value.gsub(',', ', ')
  end
  
  # If the user is an advanced user, grab their specified antiword values.
  # Antiwords are words that are deal-breakers when we filter.
  # @param key The key associated with the antiwords
  # @return The antiwords, or an empty String if none exist.
  def grab_antiwords(key)
    antiwords = DailyMessengerUtils.get_antiwords(key)
    if antiwords
      return antiwords.gsub(',', ', ')
    else
      return ""
    end
  end
end
