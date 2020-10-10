class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email:params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      flash[:success] = "ログインしました。"
      login(user)
      redirect_to user
    else
      flash[:info] = "ログインできませんでした。"
      redirect_to login_path
    end
  end

  def destroy
    if logged_in
      flash[:success] = "ログアウトしました。"
      logout
      redirect_to users_path
    end
  end
end
