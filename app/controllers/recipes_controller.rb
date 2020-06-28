class RecipesController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  skip_before_action :authenticate_user!, only: %i[index show] # You don't want update or upload_photo here

  def index
    @recipes = Recipe.last(10)
    @recipe_iterator = 0
  end

  def show
    @recipe = Recipe.find(params[:id])
    authorize @recipe
    @ingredients = @recipe.ingredients.order(created_at: :asc)
    @units = Ingredient::UNITS
    @user_can_edit = user_is_owner_or_admin?
  end

  def update
    @recipe = Recipe.find(params[:id])
    authorize @recipe
    if @recipe.update(recipe_params)
      # flash[:notice] = "Success"
      # Show positive flash message somehow
    else
      # Show negative flash message somehow
      # flash[:notice] = "Fail"

      # Alternative to this, we could use a redirect, or just re-render the partial that it was updating without refreshing the page
      # Not sure this works
      render :show
    end
  end

  def upload_photo
    @recipe = Recipe.find(params[:id])
    authorize @recipe
    if @recipe.update(recipe_params)
      @result = 'success'
      respond_to do |format|
        format.js
      end
    else
      @result = 'fail'
      respond_to do |format|
        format.js
      end
      # Show negative flash message somehow

      # Alternative to this, we could use a redirect, or just re-render the partial that it was updating without refreshing the page
      # Not sure this works
      # render :show
    end
  end

  def mark_as_complete
    # Add pundit
    @recipe = Recipe.find(params[:id])
    if @recipe.complete
      redirect_to recipe_path(@recipe)
    else
      # Do something
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :process, :photo)
  end

  def user_is_owner_or_admin?
    return false unless current_user

    @recipe.user == current_user || current_user&.admin
  end
end
