class IngredientsController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  skip_before_action :authenticate_user!, only: %i[create update] # You don't want create update here
  def create
    @ingredient = Ingredient.new(ingredient_params)
    @ingredient.save
    render json: @ingredient.to_json
  end

  def update
    # Return unless the current user is admin or the recipe owner

    # Remember, 'amount' is now a string. Add a check so that any numbers
    # are typed (for example 'one, two, three'), they get saved as, for
    # example 1, 2, 3.
    # A possible alternative/addition to this is to require numbers for
    # when the unit would usually expect a number (for example, grams, pound
    # kilos etc).
    puts "😬😬😬😬😬😬😬😬😬😬😬😬😬😬😬😬😬😬😬😬😬"
    @ingredient = Ingredient.find(params[:id])
    if @ingredient.update(ingredient_params)
      # Show positive flash message somehow
    else
      # Show positive flash message somehow
      # Re-render the page
    end
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:recipe_id, :amount, :unit, :food, :preparation)
  end
end

# The idea for ingredients, is to have a '+' button below all the
# ingredients. If this is clicked, a new 'blank' ingredient gets
# created (via the 'create' method) and added to the form.

# Data being added to this will then be handled via the 'update'
# method (via an ajax request) and updated on the page in a similar
# way as other fields are (probably just displaying the input values
# until the page is refreshed).

# Blank ingredients that get added, but not completed, will have to be
# destroyed some way. As will existing ingredients that have no data -
# not sure how to do this yet.

# Ingredients should also be able to be deleted (probably by pressing
# a 'delete' button that appears next to each ingredient; if possible
# only when that ingredient is hovered over).
