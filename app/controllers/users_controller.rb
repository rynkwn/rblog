class UsersController < ApplicationController
  
  before_action :logged_in_user?, 
                :only => [
                          :my_daily_messenger,
                          :daily_messenger_edit
                         ]
    
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
    
    if(! user.service_daily)
      @dm = ServiceDaily.new
      @dm.user = user
      @dm.save!
    else
      @dm = user.service_daily
    end
  end
  
  def daily_messenger_edit
    user = current_user
    
    @dm = user.service_daily
    
    modified_params = service_daily_params
    modified_params[:key_words] = space_comma_parser(params[:service_daily][:key_words])
    modified_params[:sender] = comma_parser(params[:service_daily][:sender])
    
    if @dm.update_attributes(modified_params)
      redirect_to my_daily_messenger_path
      flash[:success] = "Daily Messenger Preferences updated!"
    else
      redirect_to my_daily_messenger_path
      flash[:danger] = "Snap. Something went wrong."
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
  
  # Parses just by commas
  # Copied from Blogs_Controller
  def comma_parser(words)
    parsed = words.split(/[,]/)
    parsed = parsed.map(&:strip)
    parsed = parsed.map {|x| x = x.gsub(/\s+/, ' ')}
    parsed = parsed.map(&:downcase)
    parsed = parsed.reject(&:blank?)
    return parsed
  end
  
  # Parse by spaces and commas.
  def space_comma_parser(words)
    parsed = words.split(/[\s,]/)
    parsed = parsed.map(&:downcase)
    parsed = parsed.reject(&:blank?)
    return parsed
  end
end
