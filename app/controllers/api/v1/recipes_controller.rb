class Api::V1::RecipesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  before_action :set_and_authorise_recipe, except: :index

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

  private

  def recipe_params
    params.require(:recipe).permit(:name, :process)
  end

  def render_error
    render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
  end

  def set_and_authorise_recipe
    @recipe = Recipe.find(params[:id])
    authorize @recipe
  end
end
