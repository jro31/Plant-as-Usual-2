module ApplicationHelper
  def component_classes(component)
    "#{component} #{display_mode(component)}"
  end

  def display_mode(element)
    return "#{element}-light-mode" unless user_signed_in?

    current_user.dark_mode ? "#{element}-dark-mode" : "#{element}-light-mode"
  end

  def page_title
    if controller_name == 'pages' && action_name == 'home'
      "#{base_title} - Plant based recipes"
    else
      prefix = if @recipe
                @recipe.name
               elsif controller_name == 'recipes' && action_name == 'index'
                recipe_index_page_title_prefix
               elsif controller_name == 'sessions' && action_name == 'new'
                'Sign in'
               elsif controller_name == 'registrations' && action_name == 'new'
                'Sign up'
               end
      "#{prefix << ' - ' if prefix}#{base_title}"
    end
  end

  private

  def base_title
    'Plant as Usual'
  end

  def recipe_index_page_title_prefix
    case @recipe_filter
    when 'user_is_owner'
      'My recipes'
    when 'user_favourites'
      'Favourite recipes'
    when 'search'
      "#{@search_query.capitalize} recipes"
    else
      nil
    end
  end
end
