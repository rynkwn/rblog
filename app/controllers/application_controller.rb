class ApplicationController < ActionController::Base
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  include SessionsHelper
  
  # Creates an object from a json input.
  def create_from_json(json)
    if(json["type"] == "subject")
      subject = Subject.new(name: json["name"])
      subject.save
    elsif(json["type"] == "blog")
      subject = Subject.find_by(name: json["subject"])
      
      # TODO: Is there a more elegant way of doing this without explicitly
      # assigning everything?
      blog = subject.blogs.new(name: json["name"],
                               date_created: json["date_created"],
                               content: json["content"],
                               tags: json["tags"]
                              )
      blog.save
    end
  end
end
