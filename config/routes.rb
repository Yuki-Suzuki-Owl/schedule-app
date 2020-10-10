Rails.application.routes.draw do
  # get 'sessions/new'
  # get 'users/new'
  # get 'users/edit'
  root to:"users#index"
  get  'login',to:"sessions#new"
  post 'login',to:"sessions#create"
  delete 'logout',to:"sessions#destroy"
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
