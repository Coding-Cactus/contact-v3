class AddCommentsCountToTicket < ActiveRecord::Migration[7.0]
  def change
    add_column :contact_tickets, :comments_count, :integer
  end
end
