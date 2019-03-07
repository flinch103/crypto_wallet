# Responsible for storing and accessing users information
class Transaction < ApplicationRecord
  belongs_to :wallet
  belongs_to :task, class_name: 'Task', optional: true
  enum status: { pending: 0, success: 1, rejected: 2, failed: 3 }
  scope :pending_tx, -> { where(status: 'pending') }
  enum tx_type: { 'platform_stack': 0, 'wage': 1, 'task_stack': 2, 'approve': 3, 'add_job': 4, 'apply_job': 5, 'job_submit': 6, 'job_reject': 7, 'job_accept': 8, 'job_dispute': 9, 'job_vodiant_favor': 10, 'job_vodeer_favor': 11 }

  def self.filter_list(user, wallet_id)
    query = "(wallet_id = #{wallet_id} OR task_id in(select id from tasks WHERE"
    if user.vodiant?
      query << " (vodiant_id = #{user.id}"
    else
      query << " (vodeer_id = #{user.id}"
    end
    query << " AND tasks.status = 5) OR (resolved_id = #{user.id} AND tasks.status = 6))) AND  tx_type in(0,4)"
    where(query)
  end

end
