class AddDarkModeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :dark_mode, :boolean, default: false
  end
end
