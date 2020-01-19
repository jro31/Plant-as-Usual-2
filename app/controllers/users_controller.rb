class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(view_mode) # We don't want this here

  def current_user_id
    render json: { id: current_user.id } # What happens if logged-out?
  end

  def view_mode # Spec this
    @user = User.find(params[:id])
    if @user.dark_mode
      @user.update_attribute(:dark_mode, false)
    else
      @user.update_attribute(:dark_mode, true)
    end
  end
end
