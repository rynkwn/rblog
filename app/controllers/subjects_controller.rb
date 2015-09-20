class SubjectsController < ApplicationController
  
  def new
    @subject = Subject.new
  end
  
  def create
    @subject = Subject.new(blog_params)
    if @subject.save!
      flash[:success] = "Blog saved!"
    else
      render 'new'
      flash[:danger] = "Blog creation failed!"
    end
  end
  
  private
  def subject_params
    params.require(:subject).permit(:name)
  end
end
