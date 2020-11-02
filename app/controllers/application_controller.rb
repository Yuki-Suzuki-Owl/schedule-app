class ApplicationController < ActionController::Base
  include SessionsHelper

  private
  def login_user
    if !logged_in
      redirect_to login_path,notice:"ログインが必要です"
    end
  end
  
  def logged_in_user
    if current_user
      redirect_to schedule_path(current_user.id),notice:"既にログインしています"
    end
  end
end
