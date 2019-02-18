class Task < ApplicationRecord
  enum status: [:open, :progress, :completed, :rejected, :disputed, :closed]

  belongs_to :vodiant, class_name: 'User', foreign_key: 'vodiant_id'
  belongs_to :vodeer, class_name: 'User', foreign_key: 'vodeer_id', optional: true
  belongs_to :arbiter, class_name: 'User', foreign_key: 'arbiter_id', optional: true

  validates :title, presence: true, length: { maximum: 30 }
  validates :description, :start_date, :end_date, :wage, :max_vodeer , presence: true

  # returns all recently updated tasks with status either open, inprogress or completed
  scope :get_recent_updated_tasks, -> { where('status IN(?)', [0, 1, 2]).order('updated_at DESC') }
end