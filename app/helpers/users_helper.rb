module UsersHelper
  
  #############################################################
  #
  # Daily Messenger related functions
  #
  #############################################################
  
  # If the user is an advanced user, get the keywords specified by the user.
  # @param key The key associated with the keywords
  # @param value The default value associated with the keyword.
  def grab_keyword_values(key, value)
    if @dm.advanced?
      value = @dm.adv_keywords[key].gsub(',', ', ')
    else
      value = value.gsub(',', ', ')
    end
    return value
  end
  
  # If the user is an advanced user, grab their specified antiword values.
  # Antiwords are words that are deal-breakers when we filter.
  # @param key The key associated with the antiwords
  def grab_antiword_values(key)
    
    if @dm.advanced?
    else
    end
    return 
end
