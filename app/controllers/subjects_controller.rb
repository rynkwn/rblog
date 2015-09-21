class SubjectsController < ApplicationController
  
  def new
    @subject = Subject.new
  end
  
  def create
    @subject = Subject.new(subject_params)
    if @subject.save!
      redirect_to root_path
      flash[:success] = "Subject created!"
    else
      render 'new'
      flash[:danger] = "Subject creation failed!"
    end
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
