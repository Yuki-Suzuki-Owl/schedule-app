class SessionsController < ApplicationController
  before_action :logged_in_user,only:[:new,:create]
  def new
  end

  def create
    user = User.find_by(email:params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      flash[:success] = "ログインしました。"
      login(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to schedule_path(user.id)
    else
      flash[:info] = "ログインできませんでした。"
      redirect_to login_path
    end
  end

  def destroy
    if logged_in
      flash[:success] = "ログアウトしました。"
      logout
      redirect_to root_path
    end
  end
end
