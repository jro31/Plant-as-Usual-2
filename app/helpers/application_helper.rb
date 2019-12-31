module ApplicationHelper
  def display_mode(component)
    return "#{component}-light-mode" unless user_signed_in?

    current_user.dark_mode ? "#{component}-dark-mode" : "#{component}-light-mode"
  end
end
