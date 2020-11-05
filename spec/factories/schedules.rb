FactoryBot.define do
  factory :schedule do
    starttime { "2020-10-12 13:00:00" }
    endtime { "2020-10-12 14:00:00" }
    title { "Title" }
    things { "Things" }
    user
    schedule_day { Date.today }
  end
end
