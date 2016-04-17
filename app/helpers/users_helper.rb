module UsersHelper
  
  #############################################################
  #
  # Daily Messenger related functions
  #
  #############################################################
  
  def grab_keyword_values
    if !@dm.adv_keywords.empty?
      @dm.adv_keywords
    else
      
    end
  end
end
