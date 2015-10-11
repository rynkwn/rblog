class SubjectsController < ApplicationController
  before_action :authorized?, :except => :overview
  
  def new
    @subject = Subject.new
  end
  
  def create
    @subject = Subject.new(subject_params)
    if @subject.save
      redirect_to root_path
      flash.now[:success] = "Subject created!"
    else
      render 'new'
      flash.now[:danger] = "Subject creation failed!"
    end
  end
  
  def index
    @subjects = Subject.all
  end
  
  def edit
    @subject = Subject.find(params[:id])
  end
  
  def update
    @subject = Subject.find(params[:id])
    if @subject.update_attributes(subject_params)
      flash.now[:success] = "Subject updated"
    end
    redirect_to subjects_path
  end
  
  def destroy
    if Subject.exists?(params[:id])
      Subject.delete(params[:id])
      flash[:success] = "Subject Deleted"
    else
      flash[:danger] = "Subject could not be found!"
    end
    redirect_to subjects_path
  end
  
  def overview
    if Subject.exists?(params[:id])
      @subject = Subject.find(params[:id])
      @blogs = @subject.blogs.order(date_created: :asc)
    else
      redirect_to root_path
    end
  end
  
  private
  def subject_params
    params.require(:subject).permit(:name)
  end
end
