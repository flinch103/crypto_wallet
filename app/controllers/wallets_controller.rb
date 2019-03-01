# wallets Controller
class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_wallet_setup, only: :show
  def create
    outcome = Wallets::CreateIntr.run(create_wallet_params.merge(user: current_user))
    return render json: { response: { message: I18n.t('wallets.created') } } if outcome.valid?

    render json: { message: outcome.errors.full_messages.to_sentence }, status: :bad_request
  end

  def show
    @wallet = current_user.wallet
    @transactions = @wallet.transactions.where(tx_type: [0, 4]).paginate(page: params[:page], per_page: 5)
  end
  private

  def create_wallet_params
    params.permit(:address, :balance)
  end
end
