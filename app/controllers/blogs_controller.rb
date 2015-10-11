class BlogsController < ApplicationController
  before_action :authorized?, :except => :show
  
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
      redirect_to blog_path(@blog)
    else
      render 'new'
      flash.now[:danger] = "Blog creation failed!"
    end
  end
  
  # Creates an instance of the object from a json string
  def create_from_hash(json)
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
  
  def show
    if Blog.exists?(params[:id])
      @blog = Blog.find(params[:id])
    else
      flash.now[:danger] = "This... isn't the blog. (We lost it)."
      redirect_to root_path
    end
  end
  
  def index
    @blogs = Blog.all
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
    render 'show'
  end
  
  def destroy
    if Blog.exists?(params[:id])
      Blog.delete(params[:id])
      flash[:success] = "Blog Deleted"
    else
      flash[:danger] = "Blog not found to be deleted"
    end
    redirect_to blogs_path
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