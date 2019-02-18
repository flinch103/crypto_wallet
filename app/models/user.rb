# Responsible for storing and accessing users information
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, authentication_keys: [:username]

  enum role: [:vodiant, :vodeer, :arbiter]

  validates :username, uniqueness: true, presence: true
  validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  validate :validate_username
  has_one :wallet, dependent: :destroy

  has_many :tasks, class_name: 'Task', foreign_key: 'vodiant_id'
  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'vodeer_id'
  has_many :disputed_tasks, class_name: 'Task', foreign_key: 'arbiter_id'

  def validate_username
    errors.add(:username, :invalid) if User.where(email: username).exists?
  end
end
