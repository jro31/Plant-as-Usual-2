class AccountsController < ApplicationController
  def show
    @updatable_columns = User::EDITABLE_COLUMNS
  end

  def update_username
    raise
  end

  def update_email
    raise
  end
end
