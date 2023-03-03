class Infraction < ApplicationRecord
  self.table_name = 'contact_infractions'

  default_scope { order(timestamp: :asc) }

  belongs_to :user
  belongs_to :ticket

  validates :action, :reason, :moderator, :timestamp, presence: true
end
