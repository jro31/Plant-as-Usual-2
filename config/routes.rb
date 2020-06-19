Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :recipes do
    # get 'display_photo', on: :member
    patch 'upload_photo', on: :member
    resources :ingredients
  end

  get 'current_user_data' => "users#current_user_data"
  patch '/users/toggle_dark_mode/:id', to: 'users#toggle_dark_mode'
end
