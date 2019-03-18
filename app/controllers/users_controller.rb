class UsersController < ApplicationController
  skip_before_action :login_required

  def new
    if current_user
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "登録に成功しました"
    else
      render :new
    end
  end

  def show
    @user = User.find(current_user.id)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
