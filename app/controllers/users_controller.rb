class UsersController < ApplicationController
  
  before_action :logged_in_user?, :only => [
                                            :my_daily_messenger,
                                            :daily_messenger_edit
                                           ]
  before_action :correct_user, :only => [
                                         :destroy
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
  
  def destroy
    if(params[:confirm] == 'yes')
      User.find(params[:id]).destroy
      redirect_to root_path
      flash[:success] = "We'll always have Paris"
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
  
  def my_daily_messenger_change
    respond_to do |format|
      format.js {}
    end
  end
  
  def daily_messenger_edit
    user = current_user
    anti = (params["anti"] == "true") ? 1 : 0
    adv = (params["option"] == "basic") ? 0 : 1
    
    if params["option"] == "basic"
      words = params[:words]
      senders = params[:senders]
      
      @dm = user.service_daily
      
      modified_params = {}
      modified_params[:key_words] = words
      modified_params[:sender] = senders
      modified_params[:adv] = adv
      modified_params[:anti] = anti
      modified_params[:adv_keys] = []
      modified_params[:adv_keywords] = {}
      modified_params[:adv_antiwords] = {}
      modified_params[:adv_senders] = {}
      modified_params[:adv_categories] = {}
      
      if @dm.update_attributes(modified_params)
        redirect_to my_daily_messenger_path
        flash[:success] = "Daily Messenger Preferences updated!"
      else
        redirect_to my_daily_messenger_path
        flash[:danger] = "Snap. Something went wrong."
      end
    elsif params["option"] == "advanced"
      words = params[:words]
      @dm = user.service_daily
      
      advkeys = params["advkeys"]
      antiwords = params["antiwords"]
      senders = params["senders"]
      categories = params["categories"]
      
      # Cleaning.
      # WARNING. BE CAREFUL. WITH THE WRONG TINKERING, CAN LEAD TO UNDEFINED
      # BEHAVIOR.
      # http://stackoverflow.com/questions/812541/ruby-change-each-value-in-a-hash-with-something-like-collect-for-arrays
      advkeys.each do |k, v|
        val = v.split(',').map {|x| x.strip.downcase}
        advkeys[k] = val.join(',')
      end
      
      antiwords.each do |k, v|
        val = v.split(',').map {|x| x.strip.downcase}
        antiwords[k] = val.join(',')
      end
      
      senders.each do |k, v|
        val = v.split(',').map {|x| x.strip.downcase}
        senders[k] = val.join(',')
      end
      
      categories.each do |k, v|
        val = v.split(',').map {|x| x.strip.downcase}
        val = val.map {|x| DailyMessengerUtils.format_category(x)}
        categories[k] = val.join(',')
      end
      
      # Now we aggregate our formatted data to update our @dm object.
      formatted_params = {}
      formatted_params[:adv] = adv
      formatted_params[:anti] = anti
      formatted_params[:key_words] = []
      formatted_params[:sender] = []
      formatted_params[:adv_keys] = words
      formatted_params[:adv_keywords] = advkeys
      formatted_params[:adv_antiwords] = antiwords
      formatted_params[:adv_senders] = senders
      formatted_params[:adv_categories] = categories
      
      if @dm.update_attributes(formatted_params)
        redirect_to my_daily_messenger_path
        flash[:success] = "Daily Messenger Preferences updated!"
      else
        redirect_to my_daily_messenger_path
        flash[:danger] = "Snap. Something went wrong."
      end
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
                                          :sender,
                                          :adv,
                                          :anti,
                                          :adv_keys,
                                          :adv_keywords,
                                          :adv_antiwords,
                                          :adv_senders,
                                          :adv_categories)
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
    "and widgets to play around with.\n\n" +
    
    "I always enjoy emails, so feel free to send me as many as you'd like. " +
    "Whether of bugs (the computer kind), " + 
    "bugs (the insect kind), " +
    "space, AI, or just how your day has been. " +
    "I'm not really a huge fan of bugs (the insect kind) though, so try to restrain " +
    "yourself when you send me giant popping 3D closeups.\n\n" +
    
    "The only serious service I currently have running is the Daily Messenger, " +
    "which can be found here: http://www.arg.press/my_daily_messenger (and also " +
    "under the Account tab once you log in!) " +
    "If there's anything that could make the service better for you, just drop " +
    "me an email. (You can reply to this email, any Daily Messenger email, or drop a message " + 
    "directly to rynkwn@gmail.com) " +
    "If you'd rather be anonymous, there's also this form: http://goo.gl/forms/ZNrt8NCPk9\n\n" + 
    
    "Enjoy,\n\n"+
    "Ryan"
    
    content = Stringutils::to_html(content)
    
    ServiceMailer::email(
                          subject,
                          receiver,
                          content
                          ).deliver
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless @user == current_user
  end
end
