Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :recipes, except: [:new, :edit] do
    patch 'upload_photo', on: :member
    patch 'mark_as_complete', on: :member
    delete 'remove_as_favourite', on: :member
    resources :ingredients, only: [:create, :update, :destroy]
    resources :user_favourite_recipes, only: [:create]
  end

  get 'current_user_data', to: "users#current_user_data"
  patch 'users/toggle_dark_mode', to: 'users#toggle_dark_mode'

  get 'admin', to: 'admin#index'
  patch 'admin/recipe_approve/:recipe_id', to: 'admin#recipe_approve', as: 'admin_recipe_approve'
  patch 'admin/recipe_approve_for_feature/:recipe_id', to: 'admin#recipe_approve_for_feature', as: 'admin_recipe_approve_for_feature'
  patch 'admin/recipe_approve_for_recipe_of_the_day/:recipe_id', to: 'admin#recipe_approve_for_recipe_of_the_day', as: 'admin_recipe_approve_for_recipe_of_the_day'
  patch 'admin/recipe_decline/:recipe_id', to: 'admin#recipe_decline', as: 'admin_recipe_decline'
end
