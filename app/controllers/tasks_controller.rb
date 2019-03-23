class TasksController < ApplicationController
  before_action :set_task, only: [:show,:edit,:update,:destroy]
  
  def index
    # 通常の場合
    @tasks = current_user.tasks.sorted

    # 終了期限でソートした場合
    if params[:sort_expired]
      @tasks = current_user.tasks.limit_date 

    # 重要度でソートした場合
    elsif params[:sort_priority]
      @tasks = current_user.tasks.priority
    end

    if params[:task]
      # ラベルでソートした場合。
      if params[:label_id]
        @tasks = Label.find(params[:task][:label_id]).related_tasks

      # paramsにserchがあれば検索を実行する
      else params[:task][:search]
        @tasks = current_user.tasks.sort_title_and_status(params[:task][:title],params[:task][:status])
      end
    end
    
    # ページネーションのための記載
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
    @task = current_user.tasks.build(task_params)
    if @task.save
      params[:task][:label_ids]&.each do |i|
        @task.related_of_task_and_labels.create(label_id: i.to_i)
      end
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
      @task = current_user.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title,
                                   :content,
                                   :limit_date,
                                   :status,
                                   :search,
                                   :priority,
                                   :label_id,
                                   related_of_task_and_labels_attributes: [label_ids: []]
      )
    end
end
