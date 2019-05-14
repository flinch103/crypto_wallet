class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_wallet_setup
  require 'will_paginate/array'

  def new
    @task = Task.new
  end

  def index
    @tasks = Task.get_tasks(params[:filter_type], current_user)
    @tasks = @tasks.select{|task| task.is_valid? }.paginate(page: params[:page], per_page: 10) if current_user.vodeer?
    @tasks = @tasks.paginate(page: params[:page], per_page: 10) unless current_user.vodeer?
    @task_type = "Open Microtasks" unless current_user.arbiter?
    @task_type = "Assigned Microtasks" if current_user.arbiter?
    @filter_type = params[:filter_type]
    if params[:filter_type].present?
      @task_type = "#{params[:filter_type].humanize} Microtasks"
      render partial: 'vodiant_list' if request.xhr? && current_user.vodiant?
      render partial: 'vodeer_list' if request.xhr? && current_user.vodeer?
      render partial: 'arbiter_list' if request.xhr? && current_user.arbiter?
    end
  end

  def create
    @task = Task.new(task_params)
    @task.vodiant_id = current_user.id
    return render json: { response: { message: I18n.t('task.created') }, id: @task.id } if @task.save

    render json: { message: @task.errors.full_messages.to_sentence }, status: :bad_request
  end

  def show
    @task = Task.find_by_id(params[:id])
    @tx_status = @task.txn_status if @task.status == "open"
    @href_link = request.base_url if (request.base_url + "/") == request.referer
    redirect_to tasks_path if @task.blank?
  end

  def update
    @task = Task.find(params[:id])
    respond_to do |format|
      format.html do
        flash[:error] = @task.errors.full_messages.join(' ').to_s unless @task.update(task_params)
        redirect_to tasks_path
      end
      format.js do
        @task.arbiter_id = User.random_arbiter if params[:task][:status].eql?('disputed')
        if @task.update(task_params)
          return render json: { response: { message: response_message, url: request.base_url + tasks_path(filter_type: :disputed) }, arbiter: @task.arbiter.wallet.address } if params[:task][:status].eql?('disputed')
          return render json: { response: { message: response_message, url: request.base_url + redirect_path_url(@task.status)} }
        end
        render json: { message: @task.errors.full_messages.to_sentence }, status: :bad_request

      end
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :start_date, :end_date, :max_vodeer, :wage, :status, :dispute_comment, :rejection_comment, :vodeer_id, :resolved_id)
  end

  def response_message
    I18n.t("task.#{params[:task][:status]}")
  end

  def redirect_path_url(status)
    if ["approved", "rejected"].include?(status)
      tasks_path(filter_type: :closed)
    elsif status == "completed"
      tasks_path(filter_type: :completed)
    else
      tasks_path(filter_type: :ongoing)
    end
  end
end
