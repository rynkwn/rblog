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
end