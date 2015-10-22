class Crush < ActiveRecord::Base
  before_save {self.name = name.downcase }
  
  def increment_fans
    self.fans += 1
    self.save!
  end
  
  # Returns name with first letter of each "word" capitalized.
  def get_name
    self.name.titleize
  end
end
