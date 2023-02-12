module Replit
  class Client
    def initialize(sid)
      @sid = sid
    end

    def get_user_infractions(id)
      data = graphql(
        Queries::GET_INFRACTIONS,
        id: id
      )

      warnings = data['user']['warnings']
      ban_data = data['getBannedBoardUser']

      warnings ||= []

      warnings.map! do |w|
        {
          action:    'WARN',
          reason:    w['reason'],
          user_id:   id,
          timestamp: w['timeCreated'],
          moderator: w['moderator']['username']
        }
      end

      unless ban_data.length == 0
        warnings << {
          action:    'BAN',
          reason:    ban_data['reason'],
          user_id:   id,
          timestamp: ban_data['timeCreated'],
          moderator: ban_data['creator']['username']
        }
      end

      warnings
    end

    private

    def graphql(query, **variables)
      payload = {
        query: query,
        variables: variables.to_json
      }

      r  = HTTP
             .cookies(
               "connect.sid": @sid
             )
             .headers(
               referer: "#{BASE_URL}/@moderation/contact",
               "X-Requested-With": 'ReplTalk"'
             )
             .post(
               "#{BASE_URL}/graphql",
               form: payload
             )

      begin data = JSON.parse(r)
      rescue
        puts "\e[31mERROR\n#{r}\e[0m"
        return nil
      end

      if data.include?('errors')
        puts "\e[31mERROR\n#{r}\e[0m"
        return nil
      end

      data = data['data'] if data.include?('data')
      data
    end
  end
end
