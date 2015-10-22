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
  
  # ada controls the ADA tool.
  def ada
    if params[:crush]
      if Crush.exists?(name: params[:crush])
        crush = Crush.find_by(name: params[:crush])
        crush.increment_fans
      else
        Crush.create(name: params[:crush], fans: 1)
      end
    end
    
    if params[:lookup]
    end
  end
end
