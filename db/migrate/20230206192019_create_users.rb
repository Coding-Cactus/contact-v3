class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :pfp
      t.string :name

      t.timestamps
    end
  end
end
