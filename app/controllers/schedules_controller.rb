class SchedulesController < ApplicationController
  before_action :login_user,only:[:index,:show,:create,:update,:destroy]
  def show
    @schedules = current_user.schedules.where(schedule_day:params[:day])
    # カレンダーから受け取った日付をスケジュールで使う。無い場合は今日の日付け使用
    if params[:day]
      @schedule_day = params[:day]
    else
      @schedule_day = Date.today
    end

    # スケジュール変更の際に変更スケジュールのIDが送られれくる
    if params[:scheduleId]
      @schedule = current_user.schedules.find_by(id:params[:scheduleId])
    else
      @schedule = current_user.schedules.build
    end
  end

  def create
    @schedule = current_user.schedules.new(schedule_params)
    if @schedule.save
      flash[:success] = "予定を作成しました。"
      # redirect_to (@schedule,@schedule.schedule_day)
      redirect_to schedule_path(current_user.id,day:@schedule.schedule_day)
    else
      flash[:danger] = "予定が作成できませんでした。"
      flash[:danger2] = @schedule.errors.full_messages
      # render "show"
      redirect_to schedule_path(current_user.id,day:@schedule.schedule_day)
    end
  end

  def update
    @schedule = current_user.schedules.find(params[:id])
    # 変更前のデータを一時保管しておき、ゼロデータでリセットし更新する
    # 問題点： 0:00の時間に変更できなくなる？
    before_starttime = @schedule.starttime
    before_endtime = @schedule.endtime
    before_title = @schedule.title
    before_things = @schedule.things
    reset_starttime = reset_endtime = Time.zone.local(Time.current.year,Time.current.month,Time.current.day,00,00,00)

    @schedule.update_columns(starttime:reset_starttime,endtime:reset_endtime)
    if @schedule.update_attributes(schedule_params)
      flash[:success] = "予定を変更しました。"
      redirect_to schedule_path(current_user.id,day:@schedule.schedule_day)
    elsif @schedule.update_attributes(title:before_title,things:before_things,starttime:before_starttime,endtime:before_endtime)
      flash[:success] = "予定が変更できませんでした。"
      # render "show"
      redirect_to schedule_path(current_user.id,day:@schedule.schedule_day)
    else
      @schedule.delete
      flash[:danger] = "エラーが発生しました。恐れいりますが、もう一度予定を作成し直してください。"
      redirect_to schedule_path(current_user.id,day:@schedule.schedule_day)
    end
  end

  def destroy
    @schedule = current_user.schedules.find(params[:id])
    if @schedule.delete
      flash[:success] = "予定を削除しました。"
      redirect_to schedule_path(current_user.id,day:@schedule.schedule_day)
    else
      flash[:success] = "予定が削除できませんでした。"
      # render "show"
      redirect_to schedule_path(current_user.id,day:@schedule.schedule_day)
    end
  end

  private
    def schedule_params
      params.require(:schedule).permit(:starttime,:endtime,:schedule_day,:title,:things)
    end
end
