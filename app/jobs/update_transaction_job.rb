class UpdateTransactionJob < ApplicationJob
  def perform(hash, status)
    tx = Transaction.find_by(tx_hex: hash)
    if tx.present?
      tx.update(status: status.downcase)
    end
  end
end