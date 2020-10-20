class SchedulesController < ApplicationController
  def show
    @schedules = current_user.schedules
    # .find(starttime:Time.current.day)
    # @schedule = current_user.schedules.build
    @a = a = current_user.schedules.find_by(id:7)
    @params = params[:scheduleId]
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
      redirect_to @schedule
    else
      flash[:success] = "予定が作成できませんでした。"
      # render "show"
      redirect_to schedule_path(current_user.id)
    end
  end

  def update
    @schedule = current_user.schedules.find(params[:id])
    before_starttime = @schedule.starttime
    before_endtime = @schedule.endtime
    reset_starttime = reset_endtime = Time.zone.local(Time.current.year,Time.current.month,Time.current.day,00,00,00)

    @schedule.update_columns(starttime:reset_starttime,endtime:reset_endtime)
    if @schedule.update_attributes(schedule_params)
      flash[:success] = "予定を変更しました。"
      redirect_to schedule_path
    elsif @schedule.update_attributes(starttime:before_starttime,endtime:before_endtime)
      flash[:success] = "予定が変更できませんでした。"
      # render "show"
      redirect_to schedule_path(current_user.id)
    else
      flash[:danger] = "エラーが発生しました。恐れいりますが、もう一度予定を作成し直してください。"
      redirect_to schedule_path(current_user.id)
    end
  end

  def destroy
    @schedule = current_user.schedules.find(params[:id])
    if @schedule.delete
      flash[:success] = "予定を削除しました。"
      redirect_to schedule_path
    else
      flash[:success] = "予定が削除できませんでした。"
      # render "show"
      redirect_to schedule_path(current_user.id)
    end
  end

  private
    def schedule_params
      params.require(:schedule).permit(:starttime,:endtime,:title,:things)
    end

    def today
    end
end
