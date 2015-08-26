Rails.application.routes.draw do
  root 'main_pages#home'
  
  resources :users
end
