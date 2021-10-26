require 'rails_helper'
RSpec.describe 'schedule機能',type: :system do
  let(:user) {FactoryBot.create(:user)}

# Create new schedule
  describe "create new schedules" do
    context "when not logged in" do
      it "go to login page" do
        # visit schedule_path(@user,day:@schedule_day)
        visit schedule_path(user,day:Date.today)
        expect(current_path).to eq login_path
        expect(page).to have_content "ログインが必要です"
      end
    end

    context "when logged in" do
      before do
        visit login_path
        fill_in "Email",with:user.email
        fill_in "Password",with:user.password
        click_button "ログイン"
        visit schedule_path(user,day:Date.today)
      end

      it "schedule page is displayed" do
        expect(current_path).to eq schedule_path(user)
      end

      it "not created if there are not enough items" do
        select '2020',from:'schedule_starttime_1i'
        select '11',from:'schedule_starttime_2i'
        select '11',from:'schedule_starttime_3i'
        select '10',from:'schedule_starttime_4i'
        select '00',from:'schedule_starttime_5i'
        click_button "登録する"
        expect(page).to have_selector 'div',text:"！？ おっと、まだスケジュールが作成されていないようです"
        expect(page).to have_content "予定が作成できませんでした。"
      end

      it "be created correctly" do
        # select '2020','11','11','10','00',from:'開始時間'
        # select '2021',from:'開始時刻'
        # select '11',from:'開始時刻'
        # select '11',from:'開始時刻'
        # select '10',from:'開始時刻'
        # select '00',from:'開始時刻'
        # find('.hidden_field',visible:false).set("2020-11-11")
        select '2020',from:'schedule_starttime_1i'
        select '11',from:'schedule_starttime_2i'
        select '11',from:'schedule_starttime_3i'
        select '10',from:'schedule_starttime_4i'
        select '00',from:'schedule_starttime_5i'
        # select '2020','11','11','13','00',from:'終了時間'
        select '2020',from:'schedule_endtime_1i'
        select '11',from:'schedule_endtime_2i'
        select '11',from:'schedule_endtime_3i'
        select '13',from:'schedule_endtime_4i'
        select '00',from:'schedule_endtime_5i'
        fill_in "タイトル",with:"プログラミング学習"
        fill_in "やる事",with:"Linux WEBサーバー構築"
        click_button '登録する'

        expect(page).to have_no_selector 'div',text:"！？ おっと、まだスケジュールが作成されていないようです"
       expect(page).to have_content '予定を作成しました。'
       expect(page).to have_selector '.starttime',text:"開始時刻 : 2020年 11月 11日 10時 00分"
       expect(page).to have_selector '.plan_content',text:"プログラミング学習"
       expect(page).to have_no_selector '.hidden_show',text:"Linux WEBサーバー構築"
       # check 'タイトル : プログラミング学習'
       # check 'label',visible:false
       find('label',text:"タイトル : プログラミング学習").click
       expect(page).to have_selector '.hidden_show',text:"Linux WEBサーバー構築"
      end
    end
  end
# Create new schedule


  # describe 'カレンダーの表示と日付けのリンク先' do
  #   before do
  #     @user = FactoryBot.create(:user,name:"user1",email:"user1@email.com")
  #     visit login_path
  #     fill_in "Email",with:@user.email
  #     fill_in "Password",with:@user.password
  #     click_button "ログイン"
  #   end
  #   it "正しく表示されている" do
  #     visit schedules_path
  #     expect(current_path).to eq schedules_path
  #     expect(page).to have_selector '.calendar-title',text:"#{Date.today.year}年 #{Date.today.month}月"
  #     click_link "#{Date.today.day}"
  #     #,href:"/schedules/#{@user.id}?day=#{Date.today}"
  #     # ↑はたしてこれでいいのか？ カレンダー内にその日付けが1つしかなかったら問題ないけど、2つあれば「どっちクリックしていいかわからん」って言われる
  #     expect(current_path).to eq schedule_path(@user)
  #     expect(page).to have_no_selector 'h2',text:"SCHEDULE DAY is #{Date.yesterday}"
  #     expect(page).to have_selector 'h2',text:"SCHEDULE DAY is #{Date.today}"
  #   end
  # end
  #
  # describe 'スケジュールの新規作成' do
  #   context '成功' do
  #     it "正しく入力される" do
  #       @schedule_day = Date.today
  #       visit schedule_path(@user,day:@schedule_day)
  #       # select '2020','11','11','10','00',from:'開始時間'
  #       # select '2021',from:'開始時刻'
  #       # select '11',from:'開始時刻'
  #       # select '11',from:'開始時刻'
  #       # select '10',from:'開始時刻'
  #       # select '00',from:'開始時刻'
  #       # find('.hidden_field',visible:false).set("2020-11-11")
  #       select '2020',from:'schedule_starttime_1i'
  #       select '11',from:'schedule_starttime_2i'
  #       select '11',from:'schedule_starttime_3i'
  #       select '10',from:'schedule_starttime_4i'
  #       select '00',from:'schedule_starttime_5i'
  #       # select '2020','11','11','13','00',from:'終了時間'
  #       select '2020',from:'schedule_endtime_1i'
  #       select '11',from:'schedule_endtime_2i'
  #       select '11',from:'schedule_endtime_3i'
  #       select '13',from:'schedule_endtime_4i'
  #       select '00',from:'schedule_endtime_5i'
  #       fill_in "タイトル",with:"プログラミング学習"
  #       fill_in "やる事",with:"Linux WEBサーバー構築"
  #       click_button '登録する'
  #       expect(page).to have_no_selector 'div',text:"！？ おっと、まだスケジュールが作成されていないようです"
  #       expect(page).to have_content '予定を作成しました。'
  #       expect(page).to have_selector '.starttime',text:"開始時刻 : 2020年 11月 11日 10時 00分"
  #       expect(page).to have_selector '.plan_content',text:"プログラミング学習"
  #       expect(page).to have_no_selector '.hidden_show',text:"Linux WEBサーバー構築"
  #       # check 'タイトル : プログラミング学習'
  #       # check 'label',visible:false
  #       find('label',text:"タイトル : プログラミング学習").click
  #       expect(page).to have_selector '.hidden_show',text:"Linux WEBサーバー構築"
  #     end
  #   end
  #
  #   context '失敗' do
  #     it "必須項目の欠如" do
  #       @schedule_day = Date.today
  #       visit schedule_path(@user,day:@schedule_day)
  #       select '2020',from:'schedule_starttime_1i'
  #       select '11',from:'schedule_starttime_2i'
  #       select '11',from:'schedule_starttime_3i'
  #       select '10',from:'schedule_starttime_4i'
  #       select '00',from:'schedule_starttime_5i'
  #
  #       select '2020',from:'schedule_endtime_1i'
  #       select '11',from:'schedule_endtime_2i'
  #       select '11',from:'schedule_endtime_3i'
  #       select '13',from:'schedule_endtime_4i'
  #       select '00',from:'schedule_endtime_5i'
  #       fill_in "タイトル",with:""
  #       fill_in "やる事",with:"Linux WEBサーバー構築"
  #       click_button '登録する'
  #       expect(page).to have_selector 'div',text:"！？ おっと、まだスケジュールが作成されていないようです"
  #       expect(page).to have_content '予定が作成できませんでした。'
  #       expect(page).to have_content 'タイトルを入力してください'
  #       expect(page).to have_no_selector '.starttime',text:"開始時刻 : 2020年 11月 11日 10時 00分"
  #     end
  #   end
  #
  # end
  #
  describe 'スケジュールの変更' do
    before do
      visit login_path
      fill_in "Email",with:user.email
      fill_in "Password",with:user.password
      click_button "ログイン"
      visit schedule_path(user,day:Date.today)
      @schedules = user.schedules.create(schedule_day:Date.today,starttime:"2020-11-12 10:00:00",endtime:"2020-11-12 13:00:00",title:"プログラミング学習",things:"Linux WEBサーバー構築")
      # visit current_path
      @schedule_day = Date.today
      visit schedule_path(user,day:@schedule_day)
    end
    context '成功' do
      it "変更に成功する" do
        click_button "変更"
        expect(page).to have_select('schedule_starttime_1i',selected:'2020')
        expect(page).to have_select('schedule_starttime_2i',selected:'11')
        expect(page).to have_select('schedule_starttime_3i',selected:'12')
        expect(page).to have_select('schedule_starttime_4i',selected:'10')
        expect(page).to have_select('schedule_starttime_5i',selected:'00')

        expect(page).to have_select('schedule_endtime_1i',selected:'2020')
        expect(page).to have_select('schedule_endtime_2i',selected:'11')
        expect(page).to have_select('schedule_endtime_3i',selected:'12')
        expect(page).to have_select('schedule_endtime_4i',selected:'13')
        expect(page).to have_select('schedule_endtime_5i',selected:'00')

        select '2020',from:'schedule_endtime_1i'
        select '11',from:'schedule_endtime_2i'
        select '12',from:'schedule_endtime_3i'
        select '15',from:'schedule_endtime_4i'
        select '00',from:'schedule_endtime_5i'
        fill_in "やる事",with:"Linux標準教科書 基本情報技術者"
        click_button "更新する"
        expect(page).to have_content '予定を変更しました。'
        expect(page).to have_selector '.starttime',text:"開始時刻 : 2020年 11月 12日 10時 00分"
        expect(page).to have_selector '.endtime',text:"終了時刻 : 2020年 11月 12日 15時 00分"
        expect(page).to have_selector '.plan_content',text:"プログラミング学習"
        find('label',text:"タイトル : プログラミング学習").click
        expect(page).to have_selector '.hidden_show',text:"Linux標準教科書 基本情報技術者"
      end
    end

    context '失敗' do
      it "必須項目の欠如" do
        click_button "変更"
        fill_in "タイトル",with:""
        click_button "更新する"
        expect(page).to have_content '予定が変更できませんでした'
        expect(page).to have_selector '.plan_content',text:"プログラミング学習"
      end
    end
  end
  #
  describe 'スケジュールの削除' do
    before do
      visit login_path
      fill_in "Email",with:user.email
      fill_in "Password",with:user.password
      click_button "ログイン"
      visit schedule_path(user,day:Date.today)
      @schedules = user.schedules.create(schedule_day:Date.today,starttime:"2020-11-12 10:00:00",endtime:"2020-11-12 13:00:00",title:"プログラミング学習",things:"Linux WEBサーバー構築")
      # visit current_path
      @schedule_day = Date.today
      visit schedule_path(user,day:@schedule_day)
    end
    context '成功' do
      # user_specと同様アラートをクリックする方法をまだ見つけていない
      it "正常に処理される" do
        page.accept_confirm do
          within ".plan_option" do
            click_link "削除"
          end
        end
        # find('alert',text:"OK",visible:false).click
        expect(page).to have_content '予定を削除しました。'
      end
    end

  end
end
