class MainPagesController < ApplicationController
  require 'json'
  
  before_action :authorized?, :only => [:data_nuke, :data_parse]

  # Compiles relevant data using the to_data function of models
  # and emails that data to my primary email address.
  def data_nuke
    if ryan?
      data = ""
      
      # Dumping the relevant data.
      Subject.all.each do |subject|
        data += subject.to_json
      end
      Blog.all.each do |blog|
        data += blog.to_json
      end
      
      Bloghistory::standard('DATA DUMP - ' + Time.now.to_s, data).deliver
      flash.now[:success] = "Data nuke launched!"
    else
      flash.now[:danger] = "Incorrect Authorization Level, Repriming coordinates " +
                           "of data nuke."
    end
  end
  
  
  def data_parse()
    data = '{"id":1,"name":"Tester","created_at":"2015-09-21T04:27:29.833Z","updated_at":"2015-09-22T06:08:41.704Z","type":"subject"}'
    @results = JSON.parse(data)
  end
end
