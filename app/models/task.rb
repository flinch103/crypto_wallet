class Task < ApplicationRecord
  enum status: [:open, :progress, :completed, :rejected, :disputed, :approved, :resolved]

  belongs_to :vodiant, class_name: 'User', foreign_key: 'vodiant_id'
  belongs_to :vodeer, class_name: 'User', foreign_key: 'vodeer_id', optional: true
  belongs_to :arbiter, class_name: 'User', foreign_key: 'arbiter_id', optional: true

  validates :title, presence: true, length: { maximum: 30 }
  validates :description, :end_date, :wage, presence: true

  validates :wage, numericality: { greater_than: 0, less_than: 999999 }

  # returns all recently updated tasks with status either open, inprogress or completed
  scope :get_recent_updated_tasks, -> { where('status IN(?)', [0, 1, 2]).order('updated_at DESC') }

  has_many :transactions

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
      Task.open&.includes(:transactions)
    else
      return user.disputed_tasks.resolved&.order('created_at DESC') if filter == 'resolved'
      user.disputed_tasks.disputed&.order('created_at DESC')
    end
  end

  def is_valid?
    return false if transactions.count == 0
    transactions.success.count == transactions.count 
  end  

  # Task status
  def txn_status
    # NEED TO FIX IF SUCCESS AND PENDIGN
    tran = transactions
    return "Success" if is_valid?
    return "Failed" if tran.blank?
    approve_trans = tran.find_by(tx_type: "approve")&.status
    add_trans = tran.find_by(tx_type: "add_job")&.status
    return "Success" if (approve_trans == "success" && add_trans == "success")
    return "Failed" if (approve_trans == "failed" || add_trans == "failed")
    return "Pending" if (approve_trans == "pending" && add_trans == "pending")
    return "Rejected" if (approve_trans == "rejected" || add_trans == "rejected")
    approve_trans&.capitalize || add_trans&.capitalize
  end

end