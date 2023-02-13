class RenameTables < ActiveRecord::Migration[7.0]
  def change
    rename_table :comments, :contact_comments
    rename_table :infractions, :contact_infractions
    rename_table :statuses, :contact_statuses
    rename_table :tickets, :contact_tickets
    rename_table :types, :contact_types
    rename_table :users, :contact_users
  end
end
