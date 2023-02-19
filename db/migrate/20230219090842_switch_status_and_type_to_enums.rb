class SwitchStatusAndTypeToEnums < ActiveRecord::Migration[7.0]
  def up
    add_column :contact_tickets, :status, :integer, default: 0
    add_column :contact_tickets, :appeal_type, :integer, default: 0

    Ticket.all.each do |t|
      t.update(
        status: %i[incomplete in-progress accepted denied][t.status_id - 1],
        appeal_type: %i[warn ban report][t.type_id - 1]
      )
    end

    remove_column :contact_tickets, :type_id
    remove_column :contact_tickets, :status_id

    drop_table :contact_types
    drop_table :contact_statuses
  end

  def down
    create_table :contact_types do |t|
      t.string :name
      t.add_index :name

      t.timestamps
    end

    create_table :contact_statuses do |t|
      t.string :name
      t.add_index :name

      t.timestamps
    end

    %w[warn ban report].each { |t| Type.create(name: t) }
    %w[incomplete in-progress accepted denied].each { |s| Status.create(name: s) }

    add_reference :contact_tickets, :type, null: false, foreign_key: true
    add_reference :contact_tickets, :status, null: false, foreign_key: true

    Ticket.all.each do |t|
      t.update(
        type_id: %w[warn ban report].index(t.appeal_type.to_s) + 1,
        status_id: %w[incomplete in-progress accepted denied].index(t.status.to_s) + 1
      )
    end

    remove_column :contact_tickets, :status
    remove_column :contact_tickets, :appeal_type
  end
end
