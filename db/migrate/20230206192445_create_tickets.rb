class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true
      t.references :status, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
