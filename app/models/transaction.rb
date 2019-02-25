# Responsible for storing and accessing users information
class Transaction < ApplicationRecord
  belongs_to :wallet
  belongs_to :task, class_name: 'Task', optional: true
  enum status: { pending: 0, success: 1, rejected: 2 }
  enum tx_type: { 'platform_stack': 0, 'wage': 1, 'task_stack': 2 }
  scope :pending_tx, -> { where(status: 'pending') }
end