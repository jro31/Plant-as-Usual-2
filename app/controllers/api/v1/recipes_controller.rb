class Api::V1::RecipesController < Api::V1::BaseController
  def index
    @recipes = policy_scope(Recipe)
  end
end
