class ApplicationController < ActionController::Base
  include SessionsHelper

  private
  def logged_in_user
    if current_user
      redirect_to schedule_path(current_user.id),notice:"既にログインしています"
    end
  end
end
