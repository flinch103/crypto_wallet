class Task < ApplicationRecord
  enum status: [:open, :progress, :completed, :rejected, :disputed, :approved]

  belongs_to :vodiant, class_name: 'User', foreign_key: 'vodiant_id'
  belongs_to :vodeer, class_name: 'User', foreign_key: 'vodeer_id', optional: true
  belongs_to :arbiter, class_name: 'User', foreign_key: 'arbiter_id', optional: true

  validates :title, presence: true, length: { maximum: 30 }
  validates :description, :end_date, :wage, presence: true

  # returns all recently updated tasks with status either open, inprogress or completed
  scope :get_recent_updated_tasks, -> { where('status IN(?)', [0, 1, 2]).order('updated_at DESC') }

  def self.get_tasks(filter, user)
    if user.vodiant?
      return user.tasks.completed&.order('created_at DESC') if filter == 'completed'
      return user.tasks.progress&.order('created_at DESC') if filter == 'ongoing'
      return user.tasks.disputed&.order('created_at DESC') if filter == 'disputed'
      user.tasks.open&.order('created_at DESC')
    elsif user.vodeer?
      return user.assigned_tasks.completed&.order('created_at DESC') if filter == 'completed'
      return user.assigned_tasks.progress&.order('created_at DESC') if filter == 'ongoing'
      return user.assigned_tasks.disputed&.order('created_at DESC') if filter == 'disputed'
      return user.assigned_tasks.approved&.order('created_at DESC') if filter == 'approved'
      return user.assigned_tasks.rejected&.order('created_at DESC') if filter == 'rejected'
      Task.open&.order('created_at DESC')
    else
      return user.disputed_tasks.completed if filter == 'completed'
      return user.disputed_tasks.progress if filter == 'ongoing'
      user.disputed_tasks.disputed
    end
  end
end