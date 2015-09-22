class MainPagesController < ApplicationController
  include Bloghistory
  
  def data_nuke
    if ryan?
      data = ""
      
      # Dumping the relevant data.
      Subject.all.each do |subject|
        data += subject.to_data
      end
      Blog.all.each do |blog|
        data += blog.to_data
      end
      
      standard('DATA DUMP - ' + Time.now.to_s, data)
    else
    end
  end
end
