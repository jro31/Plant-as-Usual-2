class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  before_action :authenticate_user!, :set_dark_mode_css_classes
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  private

  def set_dark_mode_css_classes # ADD A SPEC FOR THIS SOMEHOW
    @dark_mode_css_classes = DarkMode.css_classes
  end
end
