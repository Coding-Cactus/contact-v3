class Infraction < ApplicationRecord
  belongs_to :user

  validates :type, :reason, :creator_username, :timestamp, presence: true
end
