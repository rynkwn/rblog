class ServiceDaily < ActiveRecord::Base
  serialize :key_words, Array
  serialize :sender, Array
  
  #
  serialize :adv_keys, Array
  # Key denotes topic/heading name. E.g., "Mathematics and Statistics"
  serialize :adv_keywords, Hash
  serialize :adv_antiwords, Hash
  serialize :adv_senders, Hash  # Default value "any"
  serialize :adv_categories, Hash  # Default value "all"
  
  belongs_to :user
  
  def advanced?
    self.adv == 1
  end
  
  def anti?
    self.anti == 1
  end
end
