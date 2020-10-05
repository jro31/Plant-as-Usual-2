class AccountsController < ApplicationController
  before_action :set_user, except: :show

  def show
    @updatable_columns = User::EDITABLE_COLUMNS
    @minimum_password_length = User.password_length.min
  end

  def update_user
    unless @user.update(account_params)
      display_error_flash
    end
    redirect_to account_path
  end

  def update_password
    if @user.update_with_password(account_params)
      bypass_sign_in(@user)
      flash[:alert] = 'Success'
    else
      display_error_flash
    end
    redirect_to account_path
  end

  private

  def account_params
    params.require(:user).permit(:username, :email, :twitter_handle, :instagram_handle, :website_url, :current_password, :password, :password_confirmation)
  end

  def set_user
    @user = current_user
  end

  def display_error_flash
    flash[:alert] = @user.errors.any? ? "Fail. #{@user.errors.full_messages.to_sentence}." : "Something went wrong."
  end
end
