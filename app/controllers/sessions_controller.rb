class SessionsController < ApplicationController

  def new
    render 'new'
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:params])
      log_in user
      redirect_to root
    else
      flash[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
  end
end