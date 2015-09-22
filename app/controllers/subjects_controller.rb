class SubjectsController < ApplicationController
  
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
  
  def destroy
    if Subject.exists?(params[:id])
      Subject.delete(params[:id])
      flash.now[:success] = "Subject Deleted"
    end
    redirect_to root_path
  end
  
  def overview
    if Subject.exists?(params[:id])
      @subject = Subject.find(params[:id])
      @blogs = @subject.blogs
    else
      redirect_to root_path
    end
  end
  
  private
  def subject_params
    params.require(:subject).permit(:name)
  end
end
