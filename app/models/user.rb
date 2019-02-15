# Responsible for storing and accessing users information
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:username]

  enum role: { vodiant: 0, vodeer: 1, arbiter: 2 }

  validates :username, uniqueness: true, presence: true
  validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  validate :validate_username
  has_one :wallet, dependent: :destroy

  def validate_username
    errors.add(:username, :invalid) if User.where(email: username).exists?
  end
end
