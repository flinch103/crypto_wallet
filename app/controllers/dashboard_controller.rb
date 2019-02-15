# Dashboard Controller
class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_wallet_setup
  def index; end

  private

  def check_wallet_setup
    redirect_to setup_accounts_path(:policy) if current_user.wallet.blank?
  end
end
