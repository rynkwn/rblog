class SubjectsController < ApplicationController
  
  def new
    @subject = Subject.new
  end
  
  def create
    @subject = Subject.new(subject_params)
    if @subject.save!
      flash[:success] = "Blog saved!"
    else
      render 'new'
      flash[:danger] = "Blog creation failed!"
    end
  end
  
  def blogs
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
