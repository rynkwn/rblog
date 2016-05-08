Rails.application.routes.draw do

  resources :users
  resources :subjects
  resources :blogs
  
  #################################
  #
  # Static Page/Admin Routes
  #
  #################################
  root 'main_pages#home'
  get 'about' => 'main_pages#about'
  get 'datanuke' => 'main_pages#data_nuke'
  get 'dataparse' => 'main_pages#data_parse'
  get 'analytics' => 'main_pages#analytics'
  get 'analytics_send_data' => 'main_pages#analytics_send_data'
  get 'announcement' => 'main_pages#temp'
  
  # Admin functions related to Daily Messenger
  get 'daily_messenger_send' => 'main_pages#daily_messenger_send'
  post 'daily_messenger_send' => 'main_pages#daily_messenger_send'
  get 'daily_messenger_announcement' => 'main_pages#daily_messenger_announcement'
  post 'daily_messenger_announcement' => 'main_pages#daily_messenger_announcement'
  get 'daily_messenger_keyword_change' => 'main_pages#daily_messenger_keyword_change'
  post 'daily_messenger_keyword_change' => 'main_pages#daily_messenger_keyword_change'
  
  # aRg Competition Pages
  get 'arg_competitions' => 'projects#competitions'
  get 'arg_competition' => 'projects#competition'

  #################################
  #
  # Login/Logout Routes
  #
  #################################
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  delete 'logout' => 'sessions#destroy'
  
  #################################
  #
  # User Routes
  #
  #################################
  get 'user_delete' => 'users#destroy'
  delete 'user_delete' => 'users#destroy'
  
  #################################
  #
  # Blogs and Subject Routes
  #
  #################################
  
  # Blog Routes
  get 'overview' => 'subjects#overview'
  get 'blog_delete' => 'blogs#destroy'
  delete 'blog_delete' => 'blogs#destroy'
  
  # Subject Routes
  get 'subject_delete' => 'subjects#destroy'
  delete 'subject_delete' => 'subjects#destroy'
  
  #################################
  #
  # Project Routes
  #
  #################################
  get 'lucky' => 'projects#lucky'
  
  #################################
  #
  # Service Routes
  #
  #################################
  
  # Daily Messenger Routes
  get 'dailymessenger' => 'services#dailymessenger'
  get 'my_daily_messenger' => 'users#my_daily_messenger'
  get 'my_daily_messenger_change' => 'users#my_daily_messenger_change'
  get 'service_daily' => 'users#my_daily_messenger'
  patch 'service_daily' => 'users#daily_messenger_edit'
end
