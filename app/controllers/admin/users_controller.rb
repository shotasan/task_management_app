class Admin::UsersController < ApplicationController
  skip_before_action :login_required
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_admin

  def index
    @users = User.all.includes(:tasks)
  end
  
  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "ユーザー「#{@user.name}」を登録しました"
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "ユーザー「#{@user.name}」を更新しました"
    else
      render :new
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "ユーザー「#{@user.name}」を削除しました"
  end
  private

  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_admin
    redirect_to root_path unless current_user&.admin?
  end
end
