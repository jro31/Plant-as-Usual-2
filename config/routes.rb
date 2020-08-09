Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :recipes do # REMOVE METHODS YOU DON'T NEED
    patch 'upload_photo', on: :member
    patch 'mark_as_complete', on: :member
    delete 'remove_as_favourite', on: :member
    resources :ingredients, only: [:create, :update, :destroy]
    resources :user_favourite_recipes, only: [:create]
  end

  get 'current_user_data' => "users#current_user_data"
  patch '/users/toggle_dark_mode/:id', to: 'users#toggle_dark_mode'
end
