module ApplicationHelper
  def component_classes(component)
    "#{component} #{display_mode(component)}"
  end

  def display_mode(element)
    return "#{element}-light-mode" unless user_signed_in?

    current_user.dark_mode ? "#{element}-dark-mode" : "#{element}-light-mode"
  end
end
