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
    @summary = summarize
  end
  
  # We create a JSON object to email to a third party data storage system.
  # This JSON object contains the range of dates as well as the meta data.
  def hit_meta
    # Assume that the first and last objects correspond to
    # first and last hits made.
    first_date = Hit.first.as_json[:date_created]
    last_date = Hit.last.as_json[:date_created]
    
    summary_data = {
                    start_date: first_date,
                    end_date: last_date,
                    hits: summarize
                    }
                    
    Bloghistory::analytics_email(first_date, last_date, summary_data).deliver
    flash.now[:success] = "Analytics data sent!"
  end

  private
  # Summarize hit data.
  def summarize
    summary = Hash.new(0)
    Hit.all.each {|hit| summary[hit.page] += 1}
    return summary
  end
  
end
