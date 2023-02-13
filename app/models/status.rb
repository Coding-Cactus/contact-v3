class Status < ApplicationRecord
  self.table_name = 'contact_statuses'
  
  has_many :tickets

  validates :name, presence: true, uniqueness: true

  def display_str
    self.name.gsub('-', ' ').titlecase
  end
end
