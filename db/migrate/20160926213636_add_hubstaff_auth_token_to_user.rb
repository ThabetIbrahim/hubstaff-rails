class AddHubstaffAuthTokenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :hubstaff_auth_token, :text
  end
end
