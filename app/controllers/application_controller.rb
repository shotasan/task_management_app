class ApplicationController < ActionController::Base
  # Admin::UsersControllerでraiseされたExceptions::AuthenticationErrorを拾う
  rescue_from Exceptions::AuthenticationError, with: :user_not_authorized
  rescue_from Exceptions::AdminUserDstroyError, with: :admin_user_not_destroy
  # ビューで使用できるようにするため
  helper_method :current_user
  before_action :login_required

  private

  def user_not_authorized
    flash.now[:error] = "権限が無いよ"
    render file: "/public/AuthenticationError"
  end

  def admin_user_not_destroy
    flash[:error] = "消しちゃダメです"
    redirect_to admin_users_url
  end
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to new_session_path unless current_user
  end
end
