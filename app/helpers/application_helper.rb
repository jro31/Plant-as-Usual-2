module ApplicationHelper
  class AmountIsNotNumber < StandardError; end
  class ArgumentIsNotString < StandardError; end

  def display_mode
    return 'light-mode' unless user_signed_in?

    current_user.dark_mode ? 'dark-mode' : 'light-mode'
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

  def is_or_are(amount)
    raise ApplicationHelper::AmountIsNotNumber unless amount.is_a?(Integer) || amount.is_a?(Float)

    amount == 1 ? 'is' : 'are'
  end

  def no_or_number(amount)
    raise ApplicationHelper::AmountIsNotNumber unless amount.is_a?(Integer) || amount.is_a?(Float)

    amount.zero? ? 'no' : amount
  end

  def number_of_at_symbols(string)
    raise ApplicationHelper::ArgumentIsNotString unless string.is_a?(String)

    string.split('').count('@')
  end

  def number_of_full_stops(string)
    raise ApplicationHelper::ArgumentIsNotString unless string.is_a?(String)

    string.split('').count('.')
  end

  private

  def base_title
    'Plant as Usual'
  end

  def recipe_index_page_title_prefix
    case @recipe_filter
    when 'user_recipes'
      if @searched_for_user_id == current_user&.id
        'My recipes'
      elsif @searched_for_user_id
        "#{User.find(@searched_for_user_id).username}'s recipes"
      else
        nil
      end
    when 'user_favourites'
      'Favourite recipes'
    when 'search'
      if @search_query.present?
        "#{@search_query.capitalize} recipes"
      else
        nil
      end
    else
      nil
    end
  end
end
