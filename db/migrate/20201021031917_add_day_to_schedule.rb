class AddDayToSchedule < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules,:schedule_day,:date,null:false
  end
end
