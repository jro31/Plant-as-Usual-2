Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :recipes

  get 'current_user_id' => "users#current_user_id"
  post '/users/view_mode/:id', to: 'users#view_mode'
end
