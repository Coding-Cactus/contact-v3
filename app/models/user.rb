class User < ApplicationRecord
  self.table_name = 'contact_users'
  
  has_many :comments
  has_many :tickets, dependent: :destroy
  has_many :infractions, dependent: :destroy

  validates :username, :pfp, presence: true

  def url
    "https://replit.com/@#{self.username}"
  end
end
