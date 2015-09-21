Rails.application.routes.draw do

  resources :users
  resources :subjects
  resources :blogs
  
  # Static Page/Admin Routes
  root 'main_pages#home'
  get 'about' => 'main_pages#about'
  get 'datadump' => 'main_pages#data_dump'
  
  # Login/Logout Routes
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  
  # Blog Routes
  get 'overview' => 'subjects#overview'
end
