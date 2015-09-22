Rails.application.routes.draw do

  resources :users
  resources :subjects
  resources :blogs
  
  # Static Page/Admin Routes
  root 'main_pages#home'
  get 'about' => 'main_pages#about'
  get 'datanuke' => 'main_pages#data_nuke'
  
  # Login/Logout Routes
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  
  # Blog Routes
  get 'overview' => 'subjects#overview'
  get 'blog_delete' => 'blogs#destroy'
  delete 'blog_delete' => 'blogs#destroy'
  
  # Subject Routes
  get 'subject_delete' => 'subjects#destroy'
  delete 'subject_delete' => 'subjects#destroy'
end
