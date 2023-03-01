class User < ApplicationRecord
  self.table_name = 'contact_users'

  has_many :comments
  has_many :tickets, dependent: :destroy
  has_many :infractions, dependent: :destroy

  validates :username, :pfp, presence: true

  scope :banned, -> { where('banned = true') }

  def url
    "https://replit.com/@#{username}"
  end
end
