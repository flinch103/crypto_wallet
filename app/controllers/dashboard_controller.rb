# Dashboard Controller
class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_wallet_setup
  
  def index
    @tasks = get_tasks
    @disputed_tasks = current_user.tasks.disputed
  end

  private

  def check_wallet_setup
    redirect_to setup_accounts_path(:policy) if current_user.wallet.blank?
  end

  def get_tasks
    return current_user.tasks if current_user.vodiant?
    return current_user.assigned_tasks if current_user.vodeer?

    current_user.disputed_tasks
  end
end
