class CreateInfractions < ActiveRecord::Migration[7.0]
  def change
    create_table :infractions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :type
      t.string :reason
      t.string :creator_username
      t.datetime :timestamp

      t.timestamps
    end
  end
end
