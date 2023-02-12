class AddTicketIdToInfractions < ActiveRecord::Migration[7.0]
  def change
    add_reference :infractions, :ticket, null: false, foreign_key: true
  end
end
