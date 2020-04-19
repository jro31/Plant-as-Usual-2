class RecipesController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  skip_before_action :authenticate_user!, only: %i[index show update] # You don't want update here

  def index
    @recipes = Recipe.last(10)
    @recipe_iterator = 0
  end

  def show
    @recipe = Recipe.find(params[:id])
    @ingredients = @recipe.ingredients.order(created_at: :asc)
    @units = Ingredient::UNITS
    authorize @recipe
  end

  def update
    # Return unless the current user is admin or the recipe owner
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      # Show positive flash message somehow
    else
      # Show positive flash message somehow
      render :show # If this doesn't work, change to redirect?
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :process)
  end
end
