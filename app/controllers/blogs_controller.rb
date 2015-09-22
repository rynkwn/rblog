class BlogsController < ApplicationController
  
  def new
    @blog = Blog.new
  end
  
  def create
    modified_params = blog_params
    modified_params[:tags] = tag_parser(modified_params[:tags])

    subject = Subject.find_by(id: params[:subject][:subject_id])
    @blog = subject.blogs.new(modified_params)
    if @blog.save
      flash.now[:success] = "Blog saved!"
      redirect_to root_path
    else
      render 'new'
      flash.now[:danger] = "Blog creation failed!"
    end
  end
  
  def show
    if Blog.exists?(params[:id])
      @blog = Blog.find(params[:id])
    else
      flash.now[:danger] = "This... isn't the blog. (We lost it)."
      redirect_to root_path
    end
  end
  
  def edit
    @blog = Blog.find(params[:id])
  end
  
  def update
    @blog = Blog.find(params[:id])
    modified_params = blog_params
    modified_params[:tags] = tag_parser(modified_params[:tags])
    if @blog.update_attributes(modified_params)
      flash.now[:success] = "Blog updated"
    end
    render 'edit'
  end
  
  def destroy
    
    if Blog.exists?(params[:id])
      Blog.delete(params[:id])
      flash[:success] = "Blog Deleted"
    else
      flash.now[:danger] = "Blog not found to be deleted"
    end
    redirect_to root_path
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