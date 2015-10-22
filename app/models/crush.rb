class Crush < ActiveRecord::Base
  
  def increment_fans
    self.fans += 1
    self.save!
  end
end
