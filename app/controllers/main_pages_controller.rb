class MainPagesController < ApplicationController
  
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
      
      Bloghistory::standard('DATA DUMP - ' + Time.now.to_s, data).deliver
      flash.now[:success] = "Data nuke launched!"
    else
      flash.now[:danger] = "Incorrect Authorization Level, Repriming coordinates " +
                           "of data nuke."
    end
  end
end
