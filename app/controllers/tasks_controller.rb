class TasksController < ApplicationController
  before_action :authenticate_user!

  def new
    @task = Task.new
  end

  def index
    @tasks = get_tasks
  end

  def create
    @task = Task.new(task_params)
    @task.vodiant_id = current_user.id
    if @task.save
      redirect_to tasks_path
    else
      flash[:error] = @task.errors.full_messages.join(' ').to_s
      render 'new'
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    flash[:error] = @task.errors.full_messages.join(' ').to_s unless @task.update(task_params)
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :start_date, :end_date, :wage, :status, :max_vodeer, :vodiant_id, :vodeer_id)
  end

  def get_tasks
    return current_user.tasks if current_user.vodiant?
    return current_user.assigned_tasks if current_user.vodeer?

    current_user.disputed_tasks
  end
end
