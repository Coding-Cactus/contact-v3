class Type < ApplicationRecord
  has_many :tickets

  validates :name, presence: true, uniqueness: true

  def display_str
    self.name.gsub('-', ' ').titlecase + " Appeal"
  end
end
