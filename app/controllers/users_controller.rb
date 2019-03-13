class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      redirect_to root_path, notice: "登録に成功しました"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:users).permit(:name, :email, :password, :password_confirmation)
  end
end
