class ServiceDaily < ActiveRecord::Base
  serialize :key_words, Array
  serialize :sender, Array
  
  belongs_to :user
end
