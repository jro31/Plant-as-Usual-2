class IngredientsController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  skip_before_action :authenticate_user!, only: %i[create update destroy] # You don't want create or update or destroy here

  def create
    # ADD PUNDIT TO THIS METHOD
    params[:ingredient] = { recipe_id: params[:recipe_id] }
    @ingredient = Ingredient.new(ingredient_params)
    @recipe = Recipe.find(params[:recipe_id])
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
    # ADD PUNDIT TO THIS METHOD

    @ingredient = Ingredient.find(params[:id])
    @recipe = Recipe.find(params[:recipe_id])
    raise unless @ingredient.recipe = @recipe
    if @ingredient.update(ingredient_params)
      @recipe.revised
      # Show positive flash message somehow
    else
      # Show negative flash message somehow
      # Re-render the page
    end
  end

  def destroy
    # ADD PUNDIT TO THIS METHOD
    @ingredient = Ingredient.find(params[:id])
    @recipe = Recipe.find(params[:recipe_id])
    raise unless @ingredient.recipe = @recipe
    @ingredient.destroy
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:recipe_id, :amount, :unit, :food, :preparation, :optional)
  end
end
