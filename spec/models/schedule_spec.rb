require 'rails_helper'

RSpec.describe Schedule, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  before do
    @user = FactoryBot.create(:user)
    @schedule = FactoryBot.create(:schedule,starttime:Time.current,endtime:Time.current.ago(1.hours),user:@user)
  end

  it "starttimeが空なら無効" do
    @schedule.starttime = nil
    @schedule.valid?
    expect(@schedule.errors[:starttime]).to include("can't be blank")
  end

  it "endtimeが空なら無効" do
    @schedule.endtime = nil
    @schedule.valid?
    expect(@schedule.errors[:endtime]).to include("can't be blank")
  end

  it "titleがからなら無効" do
    @schedule.title = nil
    @schedule.valid?
    expect(@schedule.errors[:title]).to include("can't be blank")
  end

  it "titleの長さが2文字以下なら無効" do
    @schedule.title = "a"
    @schedule.valid?
    expect(@schedule.errors[:title]).to include("is too short (minimum is 2 characters)")
  end

  it "starttime,endtimeの時間かぶりは無効" do
    @schedule.starttime = Time.current
    @schedule.endtime = Time.current.ago(0.hours)
    @schedule.valid?
    expect(@schedule.errors[:starttime]).to include("time is incorrect")
  end

  it "starttime,starttimeの時間かぶりは無効" do
    # @schedule = FactoryBot.create(:schedule,starttime:Time.current,endtime:Time.current.ago(1.hours),title:"task1")
    @schedule2 = FactoryBot.build(:schedule,starttime:Time.current.ago(0.hours),endtime:Time.current.ago(2.hours),title:"task1",user:@user)
    @schedule2.valid?
    expect(@schedule2.errors[:starttime]).to include("aready habe a plan")
  end

  # it "starttimeとendtimeの間にstarttimeがあれば無効" do
  #   @schedule = FactoryBot.create(:schedule,starttime:Time.current,endtime:Time.current.ago(2.hours),title:"task1")
  #   @schedule2 = FactoryBot.build(:schedule,starttime:Time.current.ago(-1.hours),endtime:Time.current.ago(2.hours),title:"task1")
  #   @schedule2.valid?
  #   expect(@schedule2.errors[:starttime]).to include("aready habe a plan")
  #   # 未完
  # end
end
