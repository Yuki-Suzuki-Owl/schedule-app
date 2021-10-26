require 'rails_helper'

RSpec.describe Schedule, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  before do
    # @scheduleをここで保存しておくかどうか問題
    # if save
    #   schedule.rbのeach文でplan自身と比較する場合はスルーするようにする
    # else
    #   @schedules を使う場合にその都度saveする
    # end

    @user = FactoryBot.create(:user)
    @schedule = FactoryBot.build(:schedule,starttime:Time.current,endtime:Time.current + 3.hours,title:"test",things:"",user:@user,schedule_day:Date.today)
    # @schedule = @user.schedules.create(starttime:Time.current,endtime:Time.current + 1.hours,title:"test",things:"",schedule_day:Date.today)
  end

  it "starttime endtime title user関連づけ schedule_dayがあれば有効" do
    expect(@schedule).to be_valid
  end

  it "starttimeが空なら無効" do
    @schedule.starttime = nil
    @schedule.valid?
    expect(@schedule.errors[:starttime]).to include("must be starttime")
  end
  #
  it "endtimeが空なら無効" do
    @schedule.endtime = nil
    @schedule.valid?
    expect(@schedule.errors[:endtime]).to include("must be endtime")
  end

  it "titleが空なら無効" do
    @schedule.title = nil
    @schedule.valid?
    expect(@schedule.errors[:title]).to include("を入力してください")
  end

  it "titleの長さが2文字以下なら無効" do
    @schedule.title = "a"
    @schedule.valid?
    expect(@schedule.errors[:title]).to include("は2文字以上で入力してください")
  end


  it "starttime,endtimeの時間かぶりは無効" do
    @schedule.starttime = Time.current
    @schedule.endtime = Time.current
    @schedule.valid?
    expect(@schedule.errors[:starttime]).to include("：時は止めれません。")
  end

  it "starttime,endtimeがかぶってなかったら有効" do
    @schedule.starttime = Time.current
    @schedule.endtime = Time.current + 1.hours
    @schedule.valid?
    expect(@schedule).to be_valid
  end


  it "starttimeよりendtimeが早かったら無効" do
    @schedule.starttime = Time.current
    @schedule.endtime = Time.current.ago(1.hours)
    @schedule.valid?
    expect(@schedule.errors[:endtime]).to include("：時の流れに逆らってはいけません。")
  end

  it "starttimeよりendtimeが遅かったら有効" do
    @schedule.starttime = Time.current
    @schedule.endtime = Time.current + 1.hours
    expect(@schedule).to be_valid
  end


  let(:schedule2) {
    FactoryBot.build(:schedule,starttime:Time.current+10.hours,endtime:Time.current + 15.hours,title:"task1",things:"",user:@user,schedule_day:Date.today)
  }
  it "let test" do
    expect(schedule2.starttime).not_to eq(Time.current+10.hours)
    # ミリ秒単位での誤差がでるので使えない。 ミリ単位切り捨てたらいけるかも
  end


  it "既存のstarttimeと新規のstarttimeの時間かぶりは無効" do
    @schedule.save
    @schedule2 = FactoryBot.build(:schedule,starttime:Time.current,endtime:Time.current + 2.hours,title:"task1",things:"",user:@user,schedule_day:Date.today)
    @schedule2.valid?
    expect(@schedule2.errors[:starttime]).to include("：既に予定が入っています")
  end
  it "既存のstarttimeと新規のstarttimeの時間がかぶってなかったら有効" do
    @schedule.save
    @schedule2 = FactoryBot.build(:schedule,starttime:Time.current + 3.hours,endtime:Time.current + 4.hours,title:"task1",things:"",user:@user,schedule_day:Date.today)
    expect(@schedule2).to be_valid
  end


  it "既存のendtimeと新規のendtimeの時間かぶりは無効" do
    @schedule.save
    @schedule2 = FactoryBot.build(:schedule,starttime:Time.current.ago(1.hours),endtime:Time.current + 3.hours,title:"task1",things:"",user:@user,schedule_day:Date.today)
    @schedule2.valid?
    expect(@schedule2.errors[:endtime]).to include("：この時刻までの予定が既に入っています。")
  end

  it "既存のendtimeと新規のendtimeの時間がかぶってなかったら有効" do
    @schedule.save
    @schedule2 = FactoryBot.build(:schedule,starttime:Time.current.ago(2.hours),endtime:Time.current.ago(1.hours),title:"task1",things:"",user:@user,schedule_day:Date.today)
    expect(@schedule2).to be_valid
  end


  it "既存planAを囲む様な新規planBはダメ" do
    @schedule.save
    @schedule2 = FactoryBot.build(:schedule,starttime:Time.current.ago(1.hours),endtime:Time.current + 4.hours,title:"task1",things:"",user:@user,schedule_day:Date.today)
    @schedule2.valid?
    expect(@schedule2.errors[:starttime]).to include("：この時間帯にはもう既に予定が入っています。")
  end

  it "既存planAを囲んでいない新規planBは有効" do
    @schedule.save
    @schedule2 = FactoryBot.build(:schedule,starttime:Time.current.ago(1.hours),endtime:Time.current,title:"task1",things:"",user:@user,schedule_day:Date.today)
    expect(@schedule2).to be_valid
  end


  it "既存planAの中に新規planBのstarttimeがあったらダメ" do
    @schedule.save
    @schedule2 = FactoryBot.build(:schedule,starttime:Time.current + 1.hours,endtime:Time.current + 4.hours,title:"task1",things:"",user:@user,schedule_day:Date.today)
    @schedule2.valid?
    expect(@schedule2.errors[:starttime]).to include("：この時間にはもう既に予定が入っています。")
  end

  it "既存planAの中に新規planBのstarttimeがかぶってなかったら有効" do
    @schedule.save
    @schedule2 = FactoryBot.build(:schedule,starttime:Time.current + 3.hours,endtime:Time.current + 4.hours,title:"task1",things:"",user:@user,schedule_day:Date.today)
    expect(@schedule2).to be_valid
  end


  it "既存planAの中に新規planBのendtimeがあったらダメ" do
    @schedule.save
    @schedule2 = FactoryBot.build(:schedule,starttime:Time.current.ago(2.hours),endtime:Time.current + 1.hours,title:"task1",things:"",user:@user,schedule_day:Date.today)
    @schedule2.valid?
    expect(@schedule2.errors[:starttime]).to include("：次の予定と時間がかぶってしまいます。")
  end
  
  it "既存planAの中に新規planBのendtimeがかぶってなかったら有効" do
    @schedule.save
    @schedule2 = FactoryBot.build(:schedule,starttime:Time.current.ago(2.hours),endtime:Time.current,title:"task1",things:"",user:@user,schedule_day:Date.today)
    expect(@schedule2).to be_valid
  end
end
