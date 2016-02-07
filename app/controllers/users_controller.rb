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
      user_signup_email(@user.email)
      flash.now[:success] = "Hooray! Welcome to " + NAME_OF_SITE
      
      if(params[:intended_route])
        redirect_to params[:intended_route]
      else
        redirect_to root_path
      end
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
    
    words = []
    if(params[:words])
      words = params[:words].join(",")
      words = words.split(",")
    end
    
    @dm = user.service_daily
    
    modified_params = service_daily_params
    #modified_params[:key_words] = space_comma_parser(params[:service_daily][:key_words])
    #modified_params[:key_words] << words
    #modified_params[:key_words] = modified_params[:key_words].flatten.uniq]
    modified_params[:key_words] = words
    modified_params[:sender] = comma_parser(params[:service_daily][:sender])
    
    if @dm.update_attributes(modified_params)
      redirect_to my_daily_messenger_path
      flash[:success] = "Daily Messenger Preferences updated!"
    else
      redirect_to my_daily_messenger_path
      flash[:danger] = "Snap. Something went wrong."
    end
  end
  
  #####################################
  #
  # Private methods
  #
  #####################################
  
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
  
  def user_signup_email(receiver)
    subject = "Welcome to aRg!"
    content = "Hello!\n\n" +
    
    "You don't need to confirm your account or anything, and if this " + 
    "isn't something you remotely expected to see, I suggest you reply to this " + 
    "email immediately with something like 'Identity Theft is not a Joke, Ryan.'\n\n" +
    
    "That'll catch my eye.\n\n" +
    
    "Anyways... Welcome! aRg is a weird site that I spend a lot of time on. " +
    "Right now a lot of it is just blogs and smaller projects of mine, but " +
    "hopefully there'll eventually be lots of cool features, tools, services, " +
    "and widgets for you to play around with.\n\n" +
    
    "I always enjoy emails, so feel free to send me as many as you'd like. " +
    "Whether of bugs (the computer kind), " + 
    "bugs (the insect kind), the ISS, " +
    "space, AI, or just how your day has been. " +
    "I'm not really a huge fan of bugs (the insect kind) though, so try to restrain " +
    "yourself when you send me giant popping 3D closeups of insects.\n\n" +
    
    "Cheers,\n\n"+
    "Ryan"
    
    ServiceMailer::email(
                          subject,
                          receiver,
                          content
                          ).deliver
  end
end
