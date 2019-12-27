module ApplicationHelper
  def display_mode
    return 'light' unless current_user

    current_user.dark_mode ? 'dark-mode' : 'light-mode'
  end
end
