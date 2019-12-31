class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @recipes = Recipe.all # UPDATE THIS
  end

  def show
    @recipe = Recipe.find(params[:id])
    authorize @recipe
  end
end
