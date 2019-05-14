# Dashboard Controller
class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_wallet_setup
  require 'will_paginate/array'

  def index
    @tasks = get_tasks.paginate(page: params[:page], per_page: 10)
    @disputed_tasks = current_user.tasks.disputed&.order('created_at DESC').paginate(page: params[:page], per_page: 10)
    @recent_published_tasks = Task.open&.order('created_at DESC').select{|task| task.is_valid? }.paginate(page: params[:page], per_page: 10)
    @recent_working_tasks = current_user.assigned_tasks.progress&.order('created_at DESC').select{|task| task.is_valid? }.paginate(page: params[:page], per_page: 10)
    @wallet = current_user.wallet
    @platform_stack_tx = current_user.platform_stack_tx unless current_user.arbiter?
  end

  private
  
  def get_tasks
    return current_user.tasks.order('updated_at DESC') if current_user.vodiant?
    return current_user.assigned_tasks&.order('created_at DESC') if current_user.vodeer?

    current_user.disputed_tasks&.order('created_at DESC')
  end
end