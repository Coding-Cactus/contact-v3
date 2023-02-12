# frozen_string_literal: true

module Replit
  module Queries
    GET_INFRACTIONS = "
      query ($id: Int!) {
        user(id: $id) {
          warnings {
            reason
            timeCreated
            moderator { username }
          }
        }

        getBannedBoardUser(userId: $id) {
          ...on GetBannedBoardUserOutput {
            ...on BannedBoardUser {
              reason
              timeCreated
              creator { username }
            }
          }
        }
      }
    "
  end
end
