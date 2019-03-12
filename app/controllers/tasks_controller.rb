class TasksController < ApplicationController
  before_action :set_task, only: [:show,:edit,:update,:destroy]
  def index
    if params[:sort_expired]
      @tasks = Task.all.limit_date
    elsif params[:sort_priority]
      @tasks = Task.all.priority
    elsif params[:task]
      @tasks = Task.sort_title_and_status(params[:task][:title],params[:task][:status])
    else
      @tasks = Task.all.sorted
    end
    @tasks = @tasks.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: "登録に成功しました"
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "編集に成功しました"
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "削除に成功しました"
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :content, :limit_date, :status, :search, :priority)
    end
end
