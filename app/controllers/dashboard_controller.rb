# Dashboard Controller
class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_wallet_setup
  
  def index
    @tasks = get_tasks
    @disputed_tasks = current_user.tasks.disputed&.order('created_at DESC')
    @recent_published_tasks = Task.open&.order('created_at DESC')
    @recent_working_tasks = current_user.assigned_tasks.progress&.order('created_at DESC')
    @wallet = current_user.wallet
  end

  private

  def check_wallet_setup
    redirect_to setup_accounts_path(:policy) if current_user.wallet.blank?
  end

  def get_tasks
    return current_user.tasks.order('updated_at DESC') if current_user.vodiant?
    return current_user.assigned_tasks&.order('created_at DESC') if current_user.vodeer?

    current_user.disputed_tasks
  end
end