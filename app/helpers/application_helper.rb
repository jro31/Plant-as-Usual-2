module ApplicationHelper
  def display_mode(component)
    return "#{component}-light-mode" unless current_user

    current_user.dark_mode ? "#{component}-dark-mode" : "#{component}-light-mode"
  end
end
