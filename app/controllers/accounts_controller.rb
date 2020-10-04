class AccountsController < ApplicationController
  before_action :set_user, except: :show

  def show
    @updatable_columns = User::EDITABLE_COLUMNS
  end

  def update_username
    if @user.update(account_params)
      redirect_to account_path
    else
      flash[:notice] = @user.errors.any? ? "Fail. #{@user.errors.full_messages.to_sentence}." : "Something went wrong."
      redirect_to account_path
    end
  end

  def update_email
    raise
  end

  private

  def account_params
    params.require(:user).permit(:username, :email)
  end

  def set_user
    @user = current_user
  end
end
