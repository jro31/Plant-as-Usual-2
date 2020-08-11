module RecipeHelper
  def no_recipes_headline_text(recipe_filter)
    case recipe_filter
    when 'user_is_owner'
      'Nothing but sadness here'
    when 'user_favourites'
      "You haven't favourited any recipes yet"
    else
      'No results 😳'
    end
  end
end
