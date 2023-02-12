class RenameTypeToActionOnInfraction < ActiveRecord::Migration[7.0]
  def change
    rename_column :infractions, :type, :action
  end
end
