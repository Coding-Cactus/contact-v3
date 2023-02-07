class Ticket < ApplicationRecord
  paginates_per 25

  has_many :comments
  belongs_to :user
  belongs_to :type
  belongs_to :status

  validates :content, presence: true, length: { minimum: 50 }
end
