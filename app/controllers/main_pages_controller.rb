class MainPagesController < ApplicationController
  require 'json'
  
  before_action :authorized?, 
                :only => [
                          :data_nuke, 
                          :data_parse, 
                          :analytics
                        ]
  
  #############################################################
  #
  # Data emailing related functions.
  #
  #############################################################

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
  
  # Parses a data nuke and adds the embedded objects to the database.
  def data_parse
    data = params[:data]
    if !data.nil?
      data.split("ʭ").each do |dat|
        create_from_json(JSON.parse(dat))
      end
    end
  end
  
  
  #############################################################
  #
  # Analytics related functions
  #
  #############################################################
  
  # Iterates over the Hits database and returns a hash of page descriptions to
  # hit count. More options planned.
  def analytics
    @summary = Hash.new(0)  # Sets default value to non-extant keys to 0.
    
    Hit.all.each do |hit|
      @summary[hit.page] += 1 
    end
  end

end
