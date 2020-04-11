class RecipesController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  skip_before_action :authenticate_user!, only: %i[index show update] # You don't want update here

  def index
    @recipes = Recipe.last(10)
    @recipe_iterator = 0
  end

  def show
    @recipe = Recipe.find(params[:id])
    authorize @recipe
  end

  def update
    # Return unless the current user is admin or the recipe owner
    puts "💪💪💪💪💪💪💪💪💪"
    @recipe = Recipe.find(params[:id])
    @recipe.update(recipe_params)
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :process)
  end
end
