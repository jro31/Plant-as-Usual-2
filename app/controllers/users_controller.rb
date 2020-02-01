class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(current_user_data toggle_dark_mode) # We don't want this here

  def current_user_data
    return unless current_user

    render json: { id: current_user.id, dark_mode: current_user.dark_mode }
  end

  def toggle_dark_mode # Spec this
    @user = User.find(params[:id])
    # authorize @user
    @user.update(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:dark_mode)
  end
end
