# Transactions Controller
class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :wallet, only: :create
  before_action :transaction, only: :status
  def create
    transaction = @wallet.transactions.new(transaction_params)
    if transaction.save
      CheckTransactionJob.perform_later(transaction.tx_hex)
      return render json: { response: { message: I18n.t('wallets.platform') } }
    end
    render json: { message: transaction.errors.full_messages.to_sentence }, status: :bad_request
  end

  def status
    return render json: { status: @transaction.status }
  end

  private
  
  def transaction_params
    params.permit(:tx_hex, :status, :sent, :amount, :tx_type, :task_id, :wallet_id)
  end

  def wallet
    @wallet = Wallet.find_by(id: params[:wallet_id])
  end

  def transaction
    @transaction = Transaction.find_by(id: params[:id])
  end
end
