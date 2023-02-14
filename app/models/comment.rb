class Comment < ApplicationRecord
  include Replit
  include Discord

  self.table_name = 'contact_comments'

  belongs_to :user
  belongs_to :ticket, counter_cache: true

  validates :content, presence: true
  validates :moderator, inclusion: { in: [ true, false ] }

  after_create do
    if self.moderator
      Thread.new do
        Client.new(ENV['SID']).send_notification(
          self.ticket.user.username,
          "A moderator has replied to your #{self.ticket.type.display_str}",
          "https://contact.moderation.repl.co/tickets/#{self.ticket.id}"
        )
      end
    end

    begin
      Thread.new do
        Discord.send_comment(self)
      end
    rescue
      nil
    end
  end
end
