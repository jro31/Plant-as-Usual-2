class UserFavouriteRecipesController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }

  def create
    # Add pundit
    @user_favourite_recipe = UserFavouriteRecipe.new(user_favourite_recipe_params)
    @user_favourite_recipe.user = current_user
    @user_favourite_recipe.save
  end

  private

  def user_favourite_recipe_params
    params.permit(:recipe_id)
  end
end
