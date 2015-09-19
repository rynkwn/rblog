class BlogsController < ApplicationController
  
  def new
  end
  
  def create
  end
  
  private
  def blog_params
      params.require(:blog).permit(:name, 
                                   :date_created,
                                   :content,
                                   :tags)
  end
end