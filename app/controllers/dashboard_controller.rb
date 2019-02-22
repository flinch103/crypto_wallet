# Dashboard Controller
class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_wallet_setup
  
  def index
    @tasks = get_tasks
    @disputed_tasks = current_user.tasks.disputed
    @recent_published_tasks = Task.open
    @recent_working_tasks = current_user.assigned_tasks.progress
    @wallet = current_user.wallet
    @platform_stack_tx = current_user.platform_stack_tx
  end

  private
  
  def get_tasks
    return current_user.tasks.order('updated_at DESC') if current_user.vodiant?
    return current_user.assigned_tasks if current_user.vodeer?

    current_user.disputed_tasks
  end
end