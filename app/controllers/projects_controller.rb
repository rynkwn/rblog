class ProjectsController < ApplicationController
  
  def lucky
    if params[:search] && !params[:search].empty?
      @url = google(params[:search])
    end
  end
  
  def competitions
  end
  
  def competition
    id = params[:id]
    render "projects/competitions/" + id.to_s + "/competition.html.erb"
  end
  
  ## Finite State Automata page
  def fsm
    if(!params["fsm"].nil?)
      automata = params["fsm"].split("\r\n")
      automata.select! {|line| (line.include? ") node") || ((line.include?(" -- ")) && line.include?("\draw"))}
      puts automata
      puts "\n"
      
      states = []
      for line in automata
        possible_match = line.include?("node [") ? "" : line.match(/(\{\$.*\$\})/).to_s
        if(! possible_match.empty?)
          states << possible_match
        end
      end
      
      puts states
      
      states.map! { |state|
        state[2..-3]
      }
      
      puts states
      
      if(!params["input"].nil?)
        params["input"]
      end
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
