module MainPagesHelper
  
  # We create a JSON object to email to a third party data storage system.
  # This JSON object contains two things: DateRange and then a list of
  # meta data similar to analytics above.
  def hit_meta
    
    # To get the DateRange we only really need to grab the first and last row's
    # and grab their date_created information.
    first_date = Hit.first.as_json[:date_created]
    last_date = Hit.last.as_json[:date_created]
    
    # Code below is the same as summarize in controller. At least currently.
    # I may not want this to change as the analytics object changes.
    summary = Hash.new(0)
    Hit.all.each {|hit| summary[hit.page] += 1}
    
    summary_data = {
                    start_date: first_date,
                    end_date: last_date,
                    hits: summary
                    }
                    
    
  end
end
