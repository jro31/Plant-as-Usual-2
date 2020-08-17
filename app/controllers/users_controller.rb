class UsersController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }

  def current_user_data
    return unless current_user

    render json: { id: current_user.id, dark_mode: current_user.dark_mode }
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
