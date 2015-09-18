Rails.application.routes.draw do

  root 'main_pages#home'
  
  get 'about' => 'main_pages#about'
  
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  
  resources :users
end
