class Ticket < ApplicationRecord
  include Replit

  self.table_name = 'contact_tickets'

  paginates_per 25

  belongs_to :user

  enum status:      %i[incomplete in-progress accepted denied]
  enum appeal_type: %i[warn ban report]

  has_many :comments
  has_many :infractions

  validates :status,      inclusion: { in: statuses.keys }
  validates :appeal_type, inclusion: { in: appeal_types.keys }

  validates :user, :appeal_type, :status, presence: true
  validates :content, presence: true, length: { minimum: 50 }

  after_create do
    Client.new(ENV['SID']).get_user_infractions(user.id).each do |infraction|
      infractions.create(infraction)
    end

    begin
      Thread.new do
        Discord.send_ticket(self)
      end
    rescue
      nil
    end
  end

  def display_appeal_type
    "#{appeal_type.to_s.gsub('-', ' ').titlecase} Appeal"
  end

  def display_status
    status.to_s.gsub('-', ' ').titlecase
  end

  def self.appeal_types_list
    appeal_types.map { |k, _| k }
  end

  def self.statuses_list
    statuses.map { |k, _| k }
  end
end
