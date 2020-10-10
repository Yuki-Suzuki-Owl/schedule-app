class UsersController < ApplicationController
  before_action :login_user,only:[:show,:edit,:update,:destroy]
  before_action :correct_user,only:[:edit,:update]
  before_action :admin_user,only:[:destroy]#index
  before_action :logged_in_user,only:[:new,:create]

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
      redirect_to @user
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


  private
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
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

    def login_user
      if !logged_in
        redirect_to login_path,notice:"ログインが必要です"
      end
    end

    def logged_in_user
      if current_user
        redirect_to current_user,notice:"既にログインしています"
      end
    end
end
