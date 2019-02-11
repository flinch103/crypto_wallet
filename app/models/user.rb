# Responsible for storing and accessing users information
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  enum bet_type: { vodiant: 0, vodeer: 1, arbiter: 2 }

  validates :username, :email, uniqueness: true, presence: true
  validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  validate :validate_username

  def validate_username
    return true unless User.where(email: username).exists?

    errors.add(:username, :invalid)
  end
end
