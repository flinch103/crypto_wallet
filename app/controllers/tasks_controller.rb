class TasksController < ApplicationController
  before_action :authenticate_user!

  def new
    @task = Task.new
  end

  def index
    @tasks = get_tasks
    @task_type = "Open Microtasks" unless current_user.arbiter?
    @task_type = "Assigned Microtasks" if current_user.arbiter?
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
    return render json: { response: { message: I18n.t('task.created') } } if @task.save

    render json: { message: @task.errors.full_messages.to_sentence }, status: :bad_request
  end

  def show
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    respond_to do |format|
      format.html do
        flash[:error] = @task.errors.full_messages.join(' ').to_s unless @task.update(task_params)
        redirect_to tasks_path
      end
      format.js do
        @task.arbiter_id = User.random_arbiter
        return render json: { response: { message: I18n.t('task.disputed') } } if @task.update(task_params)

        render json: { message: @task.errors.full_messages.to_sentence }, status: :bad_request

      end
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :end_date, :wage, :status, :dispute_comment)
  end

  def get_tasks
    filter  = params[:filter_type]
    if current_user.vodiant?
      return current_user.tasks.completed if filter == 'completed'
      return current_user.tasks.progress if filter == 'ongoing'
      return current_user.tasks.disputed if filter == 'disputed'
      current_user.tasks.open
    elsif current_user.vodeer?
      return current_user.assigned_tasks.completed if filter == 'completed'
      return current_user.assigned_tasks.progress if filter == 'ongoing'
      return current_user.assigned_tasks.disputed if filter == 'disputed'
      return current_user.assigned_tasks.closed if filter == 'approved'
      return current_user.assigned_tasks.rejected if filter == 'rejected'
      Task.open
    else
      return current_user.tasks.completed if filter == 'completed'
      return current_user.tasks.progress if filter == 'ongoing'
      current_user.disputed_tasks
    end
  end
end
