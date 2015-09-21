class MainPagesController < ApplicationController
  include Bloghistory
  
  def data_dump
    if ryan?
      standard('DATA DUMP - ' + Time.now, "")
    else
    end
  end
end
