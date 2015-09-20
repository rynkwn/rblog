class BlogsController < ApplicationController
  
  def new
    @blog = Blog.new
  end
  
  def create
    @blog = Blog.new(blog_params)
    if @blog.save!
      flash[:success] = "Blog saved!"
    else
      render 'new'
      flash[:danger] = "Blog creation failed!"
    end
  end
  
  private
  def blog_params
      params.require(:blog).permit(:name, 
                                   :date_created,
                                   :content,
                                   :tags)
  end
end