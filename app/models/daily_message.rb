class DailyMessage < ActiveRecord::Base
  before_save {self.content = content.downcase }
  
  after_initialize :trim_daily_messages
  
  # I only want to store the 6 most recent Daily Messages
  def trim_daily_messages
    if(DailyMessage.count > 6)
      DailyMessage.destroy(DailyMessage.first.id)
    end
  end
end
