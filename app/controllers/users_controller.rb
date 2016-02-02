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
      flash[:danger] = "I'm sorry, you're not logged in!"
    end
  end
  
  def daily_messenger_edit
    @dm = ServiceDaily.find(params[:format])
    modified_params = service_daily_params
    modified_params[:key_words] = tag_parser(params[:service_daily][:key_words])
    
    if @dm.update_attributes(modified_params)
      redirect_to my_daily_messenger_path
      flash.now[:success] = "Daily Messenger Preferences updated!"
    else
      redirect_to my_daily_messenger_path
      flash.now[:danger] = "Snap. Something went wrong."
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, 
                                 :password, 
                                 :password_confirmation)
  end
  
  def service_daily_params
    params.require(:service_daily).permit(:key_words,
                                 :sender)
  end
  
  # Parses tags into an array based on typical delimiters (spaces, commas) and
  # removes whitespace.
  # Copied from Blogs_Controller
  def tag_parser(tags)
    parsed = tags.split(/[\s,']/)
    parsed.reject(&:empty?)
    return parsed
  end
end
