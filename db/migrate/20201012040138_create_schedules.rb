class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.datetime :starttime,null:false
      t.datetime :endtime,null:false
      t.string :title,null:false
      t.text :things

      t.timestamps
    end
  end
end
