Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :recipes do # REMOVE METHODS YOU DON'T NEED
    patch 'upload_photo', on: :member
    resources :ingredients # REMOVE METHODS YOU DON'T NEED
  end

  get 'current_user_data' => "users#current_user_data"
  patch '/users/toggle_dark_mode/:id', to: 'users#toggle_dark_mode'
end
