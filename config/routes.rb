Rails.application.routes.draw do
  get 'sessions/new'

  root 'main_pages#home'
  
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  
  resources :users
end
