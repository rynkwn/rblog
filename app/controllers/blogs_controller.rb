class BlogsController < ApplicationController
  
  def new
    @blog = Blog.new
  end
  
  def create
    modified_params = blog_params
    modified_params[:tags] = tag_parser(modified_params[:tags])

    subject = Subject.find_by(id: params[:subject][:subject_id])
    @blog = subject.blogs.new(modified_params)
    if @blog.save!
      flash[:success] = "Blog saved!"
      redirect_to root_path
    else
      render 'new'
      flash[:danger] = "Blog creation failed!"
    end
  end
  
  def show
  end
  
  private
  def blog_params
      params.require(:blog).permit(:name, 
                                   :date_created,
                                   :content,
                                   :tags,
                                   :subject_id)
  end
  
  # Parses tags into an array based on typical delimiters (spaces, commas) and
  # removes whitespace.
  def tag_parser(tags)
    parsed = tags.split(/[\s,']/)
    parsed.reject(&:empty?)
    return parsed
  end
end