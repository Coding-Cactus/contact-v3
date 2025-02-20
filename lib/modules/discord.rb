require 'discordrb/webhooks'

module Discord
  USERNAME = 'Mod Contact'
  PFP_URL  = 'https://contact.moderation.repl.co/favicon.png'
  CLIENT   = Discordrb::Webhooks::Client.new(url: ENV['WEBHOOK_URL'])
  COLOURS  = {
    'denied'      => 0xdd4444,
    'accepted'    => 0x66dd44,
    'incomplete'  => 0x99aaaa,
    'in-progress' => 0x11aaff
  }.freeze

  def self.send_comment(comment)
    CLIENT.execute do |builder|
      builder.username   = USERNAME
      builder.avatar_url = PFP_URL

      builder.add_embed do |embed|
        embed.title = "New Comment - Ticket ##{comment.ticket.id} - #{comment.ticket.display_appeal_type}"
        embed.url = "https://contact.moderation.repl.co/tickets/#{comment.ticket.id}"
        embed.description = comment.content
        embed.colour = COLOURS[comment.ticket.status]
        embed.timestamp = comment.created_at
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(
          url:      comment.user.url,
          name:     comment.user.username,
          icon_url: comment.user.pfp
        )
      end
    end
  end

  def self.send_ticket(ticket)
    CLIENT.execute do |builder|
      builder.username   = USERNAME
      builder.avatar_url = PFP_URL

      builder.add_embed do |embed|
        embed.title = "New Ticket - Ticket ##{ticket.id} - #{ticket.display_appeal_type}"
        embed.url = "https://contact.moderation.repl.co/tickets/#{ticket.id}"
        embed.description = ticket.content
        embed.colour = COLOURS[ticket.status]
        embed.timestamp = ticket.created_at
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(
          url:      ticket.user.url,
          name:     ticket.user.username,
          icon_url: ticket.user.pfp
        )
      end
    end
  end
end
