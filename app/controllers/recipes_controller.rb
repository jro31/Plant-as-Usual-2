class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def show
    @recipe = Recipe.find(params[:id])
    authorize @recipe
    puts "⛱⛱⛱⛱⛱⛱⛱⛱⛱⛱⛱⛱"
    puts current_user if current_user
    puts "⛱⛱⛱⛱⛱⛱⛱⛱⛱⛱⛱⛱"
  end
end
