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
  
  def my_daily_messenger
    
    user = current_user
    
    if(user)
      if(! user.service_daily)
        @dm = ServiceDaily.new
        @dm.user = user
        @dm.save!
      else
        @dm = user.service_daily
      end
    else
      redirect_to login_path
      flash.now[:danger] = "I'm sorry, you're not logged in!"
    end
      
  end
  
  # Create a daily messenger pattern and assign it to this user.
  def create_daily
    dm = ServiceDaily.create
    dm.user = @user
  end
  
  private
  def user_params
    params.require(:user).permit(:email, 
                                 :password, 
                                 :password_confirmation)
  end
end
