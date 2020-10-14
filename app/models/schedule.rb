class Schedule < ApplicationRecord
  validates :starttime,:endtime,:title,presence:true
  validates :title,length:{minimum:2}
  validate :starttime,:same_starttime_is_invalid,:same_time_is_invalid
  # ,:starttime_earlier_than_previous_endtim

  private
    def same_time_is_invalid
      errors.add(:starttime,"time is incorrect") if starttime == endtime
    end

    def same_starttime_is_invalid
      errors.add(:starttime,"aready habe a plan") if Schedule.find_by(starttime:starttime)
      # starttime.persisted?
    end

    def starttime_earlier_than_previous_endtim
      errors.add(:endtime,"aready have a plan") if starttime < endtime
    end
end
