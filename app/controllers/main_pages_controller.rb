class MainPagesController < ApplicationController
  include Bloghistory
  
  def data_nuke
    if ryan?
      standard('DATA DUMP - ' + Time.now, "")
    else
    end
  end
end
