class Infraction < ApplicationRecord
  self.table_name = 'contact_infractions'
  
  belongs_to :user
  belongs_to :ticket

  validates :action, :reason, :moderator, :timestamp, presence: true
end
