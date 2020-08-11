# Remember to add the ability for users to delete (mark as hidden) recipes

class RecipesController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  skip_before_action :authenticate_user!, only: %i[index show] # You don't want update or upload_photo here

  def index
    @recipe_filter = params[:recipe_filter]
    @recipes = filtered_recipes
    @recipe_iterator = 0
  end

  def create
    # ADD PUNDIT
    if @recipe = Recipe.create(user: current_user, name: params[:recipe][:name])
      redirect_to recipe_path(@recipe)
    else
      # DO SOMETHING
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    authorize @recipe
    @ingredients = @recipe.ingredients.order(created_at: :asc)
    @units = Ingredient.units_humanized
    @user_can_edit = user_is_owner_or_admin?
    @recipe_is_favourite = recipe_is_favourite?
    @process_placeholder = 'Write your recipe here...'
    @name_placeholder = 'What the name of your recipe?'
  end

  def update
    @recipe = Recipe.find(params[:id])
    authorize @recipe
    if @recipe.update(recipe_params)
      @recipe.revised
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
      @recipe.revised
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
    @recipe.complete
    redirect_to recipe_path(@recipe)
  end

  def remove_as_favourite
    # Add pundit
    @recipe = Recipe.find(params[:id])
    UserFavouriteRecipe.where(user: current_user, recipe: @recipe).destroy_all
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :process, :photo)
  end

  def filtered_recipes # SPEC THIS
    # When all else is equal, perhaps sort recipes by:
    # 1) State - Approved recipes before others
    # 2) Number of favourites
    # 3) Has a photo
    # or
    # 1) State - Approved
    # 2) Date created
    case @recipe_filter
    when 'user_is_owner'
      Recipe.not_hidden.where(user: current_user).order(updated_at: :desc)
    when 'user_favourites'
      current_user.favourites.available_to_show.order(name: :asc)
    else
      Recipe.available_to_show.order(created_at: :desc)
    end
  end

  def user_is_owner_or_admin?
    return false unless current_user

    @recipe.user == current_user || current_user&.admin
  end

  def recipe_is_favourite? # SPEC THIS
    return false unless current_user

    current_user.favourites.include?(@recipe)
  end
end
