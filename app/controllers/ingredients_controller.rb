class IngredientsController < ApplicationController
  class WrongRecipeError < StandardError; end

  protect_from_forgery unless: -> { request.format.json? }
  before_action :set_recipe

  def create
    authorize @recipe, :update?
    params[:ingredient] = { recipe_id: params[:recipe_id] }
    @ingredient = Ingredient.new(ingredient_params)
    @units = Ingredient.units_humanized
    @user_can_edit = true
    if @ingredient.save
      respond_to do |format|
        format.js
      end
    else
      # DO SOMETHING
    end
  end

  def update
    authorize @recipe, :update?
    @ingredient = Ingredient.find(params[:id])
    raise IngredientsController::WrongRecipeError unless @ingredient.recipe == @recipe
    if @ingredient.update(ingredient_params)
      @recipe.revised
    else
      # DO SOMETHING
    end
  end

  def destroy
    authorize @recipe, :update?
    @ingredient = Ingredient.find(params[:id])
    raise IngredientsController::WrongRecipeError unless @ingredient.recipe == @recipe
    @ingredient.destroy
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:recipe_id, :amount, :unit, :food, :preparation, :optional)
  end

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end
end
