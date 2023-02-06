class MakeNameIndexedOnTypeAndStatus < ActiveRecord::Migration[7.0]
  def change
    add_index :types, :name
    add_index :statuses, :name
  end
end
