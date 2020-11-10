require 'rails_helper'
RSpec.describe 'user機能',type: :system do

  describe 'ログイン前' do
    describe 'ログインが必要なページに行こうとした時' do

    end

    describe 'ユーザー新規登録' do
      context '失敗' do
        it "名前が未入力" do
          visit new_user_path
          fill_in "Name"    ,with:"" # user1
          fill_in "Email"   ,with:"user1@email.com"
          fill_in "Password",with:"password"
          fill_in "Password confirmation",with:"password"
          click_button "登録する"
          expect(page).to have_content "Nameを入力してください"
        end
      end

      context '成功' do
        it "登録に成功する" do
          visit new_user_path
          fill_in "Name",with:"user1"
          fill_in "Email",with:"user1@email.com"
          fill_in "Password",with:"password"
          fill_in "Password confirmation",with:"password"
          click_button "登録する"
          expect(page).to have_content "アカウントを作成しました。"
        end
      end
    end
  end


  describe 'ログイン後' do
    before do
      @user = FactoryBot.create(:user)
      visit login_path
      fill_in "Email",with:@user.email
      fill_in "Password",with:@user.password
      click_button "ログイン"
    end

    describe 'ユーザー編集' do
      context '失敗' do
        it "失敗する" do
          visit edit_user_path(@user)
          fill_in "Name",with:""
          fill_in "Email",with:""
          fill_in "Password",with:""
          fill_in "Password confirmation",with:""
          click_button "更新する"
          expect(current_path).to eq user_path(@user)
          expect(page).to have_content "Nameを入力してください"
          # expect(@user.name).to eq @user.name
          expect(page).to have_content @user.name
        end
      end

      context '成功' do
        it "成功する" do
          visit edit_user_path(@user)
          fill_in "Name",with:"Change Name"
          fill_in "Email",with:@user.email
          fill_in "Password",with:@user.password
          fill_in "Password confirmation",with:@user.password
          click_button "更新する"
          expect(current_path).to eq user_path(@user)
          expect(page).to have_content "ユーザー情報を更新しました。"
          expect(page).to have_no_content @user.name
          expect(page).to have_content "Change Name"
          # ここでは @user の名前が "Change Name" にならない？
        end
      end
    end


    describe 'ユーザー削除' do
      context '失敗' do
        it "失敗する" do
          visit users_path
          # expect(current_path).to eq users_path
          expect(current_path).to eq user_path(@user)
        end
      end

      context '成功' do
        # エラー中。。。確認ダイアログの ok ボタンをクリックする方法
        before do
           @deleteUser = FactoryBot.create(:user,name:"delete test",email:"deletTest@email.com",password:"password")
        end
        # it "成功する" do
        #   @user.toggle!(:admin)
        #   visit users_path
        #   expect(current_path).to eq users_path
        #   # click_link "削除"
        #   click_link "削除",href:user_path(@deleteUser.id)
        #   # click_on "OK"
        #   expect(page).to have_no_content "#{@deleteUser.name}"
        # end
      end
    end


    describe 'ユーザー一覧へのアクセス' do
      context '一般ユーザー' do
        it '失敗する' do
          visit users_path
          expect(current_path).to eq user_path(@user)
        end
      end

      context '管理者権限ユーザー' do
        it '成功する' do
          @user.toggle!(:admin)
          visit users_path
          expect(current_path).to eq users_path
        end
      end
    end

  end
end
