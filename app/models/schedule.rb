class Schedule < ApplicationRecord
  belongs_to :user
  validates :starttime,:endtime,:title,:schedule_day,presence:true
  validates :title,length:{minimum:2}
  # validate :starttime,:same_starttime_is_invalid,:same_time_is_invalid
  # ,:starttime_earlier_than_previous_endtim
  # 下のメソッドに変更
  validate :schedule_validation
  default_scope -> {order(starttime: :asc)}
  # バリデーションをつける

  private
    # def same_time_is_invalid
    #   errors.add(:starttime,"time is incorrect") if starttime == endtime
    # end
    #
    # def same_starttime_is_invalid
    #   errors.add(:starttime,"aready habe a plan") if Schedule.find_by(starttime:starttime)
    #   # starttime.persisted?
    # end

    # def starttime_earlier_than_previous_endtim
    #   errors.add(:endtime,"aready have a plan") if starttime < endtime
    #   これでは正しくバリデーションが効かない
    # end

    def schedule_validation
      if starttime.nil?
        errors.add(:starttime,"must be starttime")
      elsif endtime.nil?
        errors.add(:endtime,"must be endtime")
      else

        if endtime < starttime
          errors.add(:endtime,"：時の流れに逆らってはいけません。")
        elsif starttime == endtime
          errors.add(:starttime,"：時は止めれません。")
        end
        
      end

      schedules = user.schedules.where(schedule_day:schedule_day)
      # その日のデータで開始時と終了時のかぶりは無効
      # このままだと、specでテストするときに、plan自身もDBに入ってるからplan自身とコンフリクトしてしまう
      # 対策 ＝＞ plan自身と比較する場合はスルー
      schedules.each do |s|
        if s.starttime == starttime
          errors.add(:starttime,"：既に予定が入っています")
        elsif s.endtime == endtime
          errors.add(:endtime,"：この時刻までの予定が既に入っています。")
        end
      end

      # 複雑に入り組んだスケジュールは無効
      schedules.each do |s|
        # 既存planAを囲む様な新規planBはダメ
        if starttime < s.starttime && endtime > s.endtime
          errors.add(:starttime,"：この時間帯にはもう既に予定が入っています。")
        # 既存planAの中に新規planBのstarttimeがあったらダメ
        elsif starttime > s.starttime && starttime < s.endtime
          errors.add(:starttime,"：この時間にはもう既に予定が入っています。")
        # 既存planAの中に新規planBのendtimeがあったらダメ
        elsif endtime > s.starttime && endtime < s.endtime
          errors.add(:starttime,"：次の予定と時間がかぶってしまいます。")
        end
      end
    end
end
