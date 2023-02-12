class RenameCreatirUsernameToModerator < ActiveRecord::Migration[7.0]
  def change
    rename_column :infractions, :creator_username, :moderator
  end
end
