class AddBannedToContactUser < ActiveRecord::Migration[7.0]
  def change
    add_column :contact_users, :banned, :boolean, default: false
  end
end
