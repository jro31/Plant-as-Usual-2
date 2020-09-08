class UsersController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  skip_before_action :authenticate_user!, only: :current_user_data

  def current_user_data
    render json: current_user ? { id: current_user.id, dark_mode: current_user.dark_mode } : nil
  end

  def toggle_dark_mode
    @user = current_user
    @user.update(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:dark_mode)
  end
end
