class AddSocialMediaToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :twitter_handle, :string
    add_column :users, :instagram_handle, :string
    add_column :users, :website_url, :string
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
  end
end
