class SessionsController < ApplicationController
  # ApplicationControllerのbefore_actionを適用させないため
  skip_before_action :login_required

  def new
    redirect_to root_path if current_user
  end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice:"ログインしました"
    else
      flash.now.alert = "メールアドレスかパスワードが間違っています"
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "ログアウトしました"
  end

  private

  def session_params
    params.require(:sessions).permit(:email, :password)
  end
end
