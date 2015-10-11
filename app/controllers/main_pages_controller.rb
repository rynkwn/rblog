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
        data = data + subject.to_json + "ʭ"
      end
      Blog.all.each do |blog|
        data = data + blog.to_json + "ʭ"
      end
      
      Bloghistory::standard('DATA DUMP - ' + Time.now.to_s, data).deliver
      flash.now[:success] = "Data nuke launched!"
    else
      flash.now[:danger] = "Incorrect Authorization Level, Repriming coordinates " +
                           "of data nuke."
    end
  end
  
  
  def data_parse
    data = '{"id":1,"name":"SUB","created_at":"2015-10-11T20:01:32.002Z","updated_at":"2015-10-11T20:01:32.002Z","type":"subject"}ʭ{"id":1,"name":"BLO","date_created":"2015-10-11","content":"CONTENT","tags":["TAGS"],"subject_id":1,"created_at":"2015-10-11T20:01:46.949Z","updated_at":"2015-10-11T20:01:46.949Z","type":"blog","subject":"SUB"}ʭ'
    data.split("ʭ").each do |dat|
      create_from_json(JSON.parse(dat))
    end
    @show = Blog.last
  end
end
