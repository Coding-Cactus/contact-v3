require 'database_cleaner/active_record'

if Rails.env.development?
  DatabaseCleaner.clean_with(:truncation)

  User.create(
    username: "User1",
    pfp: "https://www.gravatar.com/avatar/c7214df99af74819bbc79e31bd6976a9?d=https://repl.it/public/images/evalbot/evalbot_37.png&s=256"
  )

  User.create(
    username: "User2",
    pfp: "https://www.gravatar.com/avatar/26e5f155d84515af37ddb18fae7c08b4?d=https://repl.it/public/images/evalbot/evalbot_18.png&s=256"
  )

  User.create(
    username: "User3",
    pfp: "https://www.gravatar.com/avatar/457d746c6b475745e5b4e30dae465d5b?d=https://repl.it/public/images/evalbot/evalbot_35.png&s=256"
  )
end

%w[warn ban].each { |type| Type.create(name: type)  }
%w[incomplete in-progress accepted denied].each { |status| Status.create(name: status)  }
