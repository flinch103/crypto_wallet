# Transactions Controller
class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :wallet
  def create
    transaction = @wallet.transactions.new(transaction_params)
    return render json: { response: { message: I18n.t('wallets.platform') } } if transaction.save

    render json: { message: transaction.errors.full_messages.to_sentence }, status: :bad_request
  end

  private
  
  def transaction_params
    params.permit(:tx_hex, :status, :sent, :amount, :tx_type)
  end

  def wallet
    @wallet = Wallet.find_by(id: params[:wallet_id])
  end
end
