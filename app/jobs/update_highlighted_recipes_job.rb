# Not currently called anywhere
class UpdateHighlightedRecipesJob < ApplicationJob
  def perform
    Recipe.update_highlighted_recipes
  end
end
