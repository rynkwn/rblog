class ServiceDaily < ActiveRecord::Base
  serialize :key_words, Array
  
  belongs_to :user
  
end
