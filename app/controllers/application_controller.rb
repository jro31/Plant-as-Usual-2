class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  before_action :authenticate_user!, :set_dark_mode_css_classes

  private

  def set_dark_mode_css_classes # ADD A SPEC FOR THIS SOMEHOW
    @dark_mode_css_classes = DarkMode.css_classes
  end
end
