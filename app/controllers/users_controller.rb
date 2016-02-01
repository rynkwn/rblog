class UsersController < ApplicationController
    
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash.now[:success] = "Hooray! Welcome to " + NAME_OF_SITE
    else
      render 'new'
    end
  end
  
  #####################################
  #
  # Service related methods.
  #
  #####################################
  
  def create_daily
    
  end
  
  private
  def user_params
    params.require(:user).permit(:email, 
                                 :password, 
                                 :password_confirmation)
  end
end
