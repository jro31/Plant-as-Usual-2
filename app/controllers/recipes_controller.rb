class RecipesController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_recipe, except: %i(index create)
  after_action :verify_authorized, except: [:index, :create, :show, :remove_as_favourite]

  def index
    @recipe_filter = params[:recipe_filter]
    @searched_for_user_id = params[:user_id].to_i
    @search_query = params[:query]
    @recipes = filtered_recipes
    @recipe_iterator = 0
    @h1_text = h1_index_text
  end

  def create
    if @recipe = Recipe.create(user: current_user, name: params[:recipe][:name])
      redirect_to recipe_path(@recipe)
    else
      redirect_to root_path
    end
  end

  def show
    @ingredients = @recipe.ingredients.order(created_at: :asc)
    @units = Ingredient.units_humanized
    @user_can_edit = user_is_owner_or_admin?
    @recipe_is_favourite = recipe_is_favourite?
    @process_placeholder = 'Write your recipe here...'
    @name_placeholder = 'What the name of your recipe?'
  end

  def update
    authorize @recipe
    if @recipe.update(recipe_params)
      @recipe.revised
    else
      # Something here
    end
  end

  def upload_photo
    authorize @recipe
    @user_can_edit = user_is_owner_or_admin?
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
    end
  end

  def mark_as_complete
    authorize @recipe
    @recipe.complete
    redirect_to recipe_path(@recipe)
  end

  def remove_as_favourite
    UserFavouriteRecipe.where(user: current_user, recipe: @recipe).destroy_all
  end

  def destroy
    authorize @recipe
    if @recipe.destroy
      redirect_to root_path
    else
      # Something here
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :process, :photo)
  end

  def filtered_recipes # SPEC THIS
    case @recipe_filter
    when 'user_recipes'
      if @searched_for_user_id == current_user&.id
        Recipe.not_hidden.where(user: current_user).order(updated_at: :desc)
      elsif @searched_for_user_id
        Recipe.available_to_show.where(user: User.find(@searched_for_user_id)).order(updated_at: :desc)
      else
        nil
      end
    when 'user_favourites'
      current_user.favourites.available_to_show.order(name: :asc)
    when 'search'
      ordered_recipes(Recipe.available_to_show.joins(:ingredients).where(search_sql_query, query: "%#{@search_query}%").distinct)
    else
      ordered_recipes(Recipe.available_to_show.distinct)
    end
  end

  def search_sql_query
    "recipes.name @@ :query OR ingredients.food @@ :query"
  end

  def ordered_recipes(recipes)
    first_recipes = []
    second_recipes =[]
    third_recipes = []
    fourth_recipes = []
    recipes.order(created_at: :desc).each do |recipe|
      if recipe.has_photo?
        recipe.awaiting_approval? ? second_recipes << recipe : first_recipes << recipe
      else
        recipe.awaiting_approval? ? fourth_recipes << recipe : third_recipes << recipe
      end
    end
    [first_recipes, second_recipes, third_recipes, fourth_recipes].flatten
  end

  def h1_index_text
    if @recipe_filter == 'user_recipes' && @searched_for_user_id && @searched_for_user_id != current_user&.id
      "#{User.find(@searched_for_user_id).username}'s recipes"
    elsif @recipe_filter == 'search' && @search_query
      "'#{@search_query}' recipes"
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

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end
end
