class ProjectsController < ApplicationController
  
  def lucky
    if params[:search]
      @url = google(params[:search])
    end
  end
  
  private
  
  # Temp Google Search
  def google(hint)
    search = Google::Search::Web.new do |gopher|
      gopher.query = hint
      gopher.size = :small
    end
    output = ""
    search.find { |item|  output += item.uri }
    return output
  end
end
