# Responsible for storing and accessing users information
class Wallet < ApplicationRecord
  belongs_to :user
  validates :address, presence: true

  has_many :transactions
end
