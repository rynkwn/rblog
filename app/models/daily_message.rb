class DailyMessage < ActiveRecord::Base
  after_initialize :trim_daily_messages
  
  # I only want to store the 3 most recent Daily Messages
  def trim_daily_messages
    if(DailyMessage.count > 3)
      DailyMessage.destroy(DailyMessage.first.id)
    end
  end
end
