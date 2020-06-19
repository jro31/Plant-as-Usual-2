class RecipesController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  skip_before_action :authenticate_user!, only: %i[index show update upload_photo] # You don't want update or upload_photo here

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
      # Show negative flash message somehow

      # Alternative to this, we could use a redirect, or just re-render the partial that it was updating without refreshing the page
      # Not sure this works
      render :show
    end
  end

  def upload_photo
    # Return unless the current user is admin or the recipe owner
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      # render :display_photo
      respond_to do |format|
        # format.html
        format.js
      end
    else
      # Show negative flash message somehow

      # Alternative to this, we could use a redirect, or just re-render the partial that it was updating without refreshing the page
      # Not sure this works
      # render :show
    end
  end

  # def display_photo
  #   respond_to do |format|
  #     format.js
  #   end
  # end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :process, :photo)
  end
end
