# wallets Controller
class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_wallet_setup, only: :show
  require 'will_paginate/array'
  def create
    outcome = Wallets::CreateIntr.run(create_wallet_params.merge(user: current_user))
    return render json: { response: { message: I18n.t('wallets.created') } } if outcome.valid?

    render json: { message: outcome.errors.full_messages.to_sentence }, status: :bad_request
  end

  def show
    @wallet = current_user.wallet
    @transactions = Transaction.where("(wallet_id = #{@wallet.id} OR task_id in(select id from tasks WHERE
                                       (vodeer_id = #{current_user.id} AND tasks.status = 5) OR
                                       (resolved_id = #{current_user.id} AND tasks.status = 6))) AND
                                       tx_type in(0,4)")
                               .order(created_at: :desc)
                               .paginate(page: params[:page], per_page: 5)
  end
  private

  def create_wallet_params
    params.permit(:address, :balance)
  end
end
