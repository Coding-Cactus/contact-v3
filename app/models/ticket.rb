class Ticket < ApplicationRecord
  include Replit

  paginates_per 3

  belongs_to :user
  belongs_to :type
  belongs_to :status

  has_many :comments
  has_many :infractions

  validates :user, :type, :status, presence: true
  validates :content, presence: true, length: { minimum: 50 }

  after_create do
    Client.new(ENV['SID']).get_user_infractions(self.user.id).each do |infraction|
      self.infractions.create(infraction)
      p infraction
    end
  end
end
