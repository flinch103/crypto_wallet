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

  has_many :transactions, through: :wallet
  has_many :tasks, class_name: 'Task', foreign_key: 'vodiant_id'
  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'vodeer_id'
  has_many :disputed_tasks, class_name: 'Task', foreign_key: 'arbiter_id'

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>", cust: "130x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/, if: Proc.new {|a| a.avatar.present? } 

  def validate_username
    errors.add(:username, :invalid) if User.where(email: username).exists?
  end
  
  def self.random_arbiter
    User.where(role: 'arbiter').pluck(:id).sample
  end

  def platform_stack_tx
    wallet&.transactions&.find_by(tx_type: 'platform_stack')
  end

  def self.find_for_authentication(conditions)
    conditions[:username].downcase! 
    super(conditions) 
  end 
end
