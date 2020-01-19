class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(toggle_dark_mode) # We don't want this here

  def current_user_id
    render json: { id: current_user.id } # What happens if logged-out?
  end

  def toggle_dark_mode # Spec this
    @user = User.find(params[:id])
    # authorize @user
    @user.update_attribute(:dark_mode, !@user.dark_mode)
  end
end
