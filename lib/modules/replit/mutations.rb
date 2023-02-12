# frozen_string_literal: true

module Replit
  module Mutations
    SEND_NOTIFICATION = "
      mutation($input: ModeratorNotificationInput!) {
        moderatorNotification(input: $input) {
          ... on BasicNotification { id }
        }
      }
    "
  end
end
