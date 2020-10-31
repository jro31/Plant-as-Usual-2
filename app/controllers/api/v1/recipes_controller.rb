class Api::V1::RecipesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: %i(index show)
  before_action :set_and_authorise_recipe, except: %i(create index)

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    authorize @recipe
    if @recipe.save
      render :show
    else
      render_error
    end
  end

  def index
    @recipes = policy_scope(Recipe)
  end

  def show;end

  def update
    if @recipe.update(recipe_params)
      render :show
    else
      render_error
    end
  end

  def destroy
    @recipe.destroy
    head :no_content
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :process, :photo, ingredients_attributes: %i(amount unit food preparation optional))
  end

  def render_error
    render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
  end

  def set_and_authorise_recipe
    @recipe = Recipe.find(params[:id])
    authorize @recipe
  end
end
