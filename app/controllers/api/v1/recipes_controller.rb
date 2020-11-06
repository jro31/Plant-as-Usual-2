class Api::V1::RecipesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: %i(index show)
  before_action :set_and_authorise_recipe, except: %i(create index)

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    authorize @recipe
    if @recipe.save
      mark_recipe_as_complete
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
      @recipe.revised
      mark_recipe_as_complete
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
    params.require(:recipe).permit(:name, :process, :photo, :mark_as_complete, ingredients_attributes: %i(id amount unit food preparation optional _destroy))
  end

  def render_error
    render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
  end

  def set_and_authorise_recipe
    @recipe = Recipe.find(params[:id])
    authorize @recipe
  end

  def mark_recipe_as_complete
    @recipe.complete unless [nil, '', 'false'].include?(@recipe.mark_as_complete)
  end
end
