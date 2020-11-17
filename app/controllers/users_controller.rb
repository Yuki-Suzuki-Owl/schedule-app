class UsersController < ApplicationController
  before_action :login_user,only:[:index,:show,:edit,:update,:destroy]
  before_action :correct_user,only:[:show,:edit,:update]
  before_action :admin_user,only:[:destroy,:index]
  before_action :logged_in_user,only:[:new,:create]
  # アプリ全体出使うメソッドはapplicationcontorollerに移す

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      flash[:success] = "アカウントを作成しました。"
      redirect_to schedule_path(current_user.id)
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user,notice:"ユーザー情報を更新しました。"
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.admin? || @user == current_user
      redirect_to users_path,notice:"ユーザーを削除できませんでした。"
    elsif @user.destroy
      redirect_to users_path,notice:"ユーザー#{@user.name}を削除しました。"
    else
      redirect_to users_path,notice:"ユーザーを削除できませんでした。"
    end
  end

  def set_ziel
    @user = current_user
  end

  def create_ziel
    @user = current_user
    if @user.update(ziel_params)
      redirect_to @user,notice:"目標を設定しました！"
    else
      render 'set_ziel'
    end
  end


  private
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end

    def ziel_params
      params.require(:user).permit(:ziel,:memo)
    end


    def correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        redirect_to current_user
      end
    end

    def admin_user
      unless current_user.admin?
        redirect_to current_user
      end
    end
end
