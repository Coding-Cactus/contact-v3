class Infraction < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  validates :action, :reason, :moderator, :timestamp, presence: true
end
