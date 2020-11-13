class AddReceiveEmailsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :receive_emails, :boolean, default: true
  end
end
