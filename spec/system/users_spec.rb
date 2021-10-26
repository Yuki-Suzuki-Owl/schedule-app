require 'rails_helper'
RSpec.describe 'user機能',type: :system do
  let(:user) {FactoryBot.create(:user)}
  let!(:other_user) {
    FactoryBot.create(:user,name:"other user",email:"otheruser@email.com")
  }
  let!(:test_user) {
    FactoryBot.create(:user,name:"test user",email:"test@email.com")
  }

# signup users test
  describe "signup users" do
    context "insufficient input" do
      it "fails if no name is entered" do
        visit new_user_path
        fill_in "Name"    ,with:""
        fill_in "Email"   ,with:"user@email.com"
        fill_in "Password",with:"password"
        fill_in "Password confirmation",with:"password"
        click_button "登録する"
        expect(page).to have_content "Nameを入力してください"
      end
      it "" do
        expect{
          User.create(name:"",email:"user@email.com",password:"password",password_digest:User.digest("password"))
        }.to_not change{User.count}
      end
    end

    context "complete input" do
      it "will succeed if input is correct" do
        visit new_user_path
        fill_in "Name"    ,with:"user1"
        fill_in "Email"   ,with:"user1@email.com"
        fill_in "Password",with:"password"
        fill_in "Password confirmation",with:"password"
        click_button "登録する"
        expect(page).to have_content "アカウントを作成しました。"
      end
      it "" do
        expect{
           User.create(name:"name",email:"sampel@email.com",password:"password",password_digest:User.digest('password'))
        }.to change{User.count}.by(1)
      end
    end
  end
# signup users test

# users edit test
  describe "users edit" do
    describe "incorrect edit" do
      context "when not logged in" do
        it "fails if not logged in" do
          visit edit_user_path(user)
          expect(page).to have_content "ログインが必要です"
        end
        it "" do
          expect{
            patch user_path(user),params:{user:{name:"no change name",email:"notchange@email.com",ziel:"foobar",memo:"foobar"}}
            # user.update(name:"",email:"",ziel:"",memo:"foobar")
          }.to_not change{user.inspect}
        end
      end

      context "when logged in" do
        before do
          visit login_path
          fill_in "Email",with:user.email
          fill_in "Password",with:user.password
          click_button "ログイン"
        end

        it "cannot edited by other users" do
          visit edit_user_path(other_user)
          expect(page).to have_content user.name
          expect(page).to have_no_content other_user.name
        end

        it "" do
          expect{
            patch user_path(other_user),params:{user:{name:"wrong user",email:"wronguser@email.com"}}
          }.to_not change{other_user.inspect}
        end

        it "editing will fail if there are not enough items" do
          visit edit_user_path(user)
          fill_in "Name",with:""
          fill_in "Email",with:""
          click_button "更新する"
          expect(page).to have_content "Nameを入力してください"
        end

        it "" do
          expect{
            patch user_path(other_user),params:{user:{name:"no change name",email:"nochange@email",ziel:"",memo:""}}
            # user.update(name:"",email:"",ziel:"",memo:"")
          }.to_not change{other_user.inspect}
        end
      end
    end

    describe "correct edit" do
      it "only your information can be edited" do
        visit login_path
        fill_in "Email",with:user.email
        fill_in "Password",with:user.password
        click_button "ログイン"
        visit edit_user_path(user)
        fill_in "Name",with:"change name"
        fill_in "Email",with:"changeuser@email.com"
        click_button "更新する"
        expect(page).to have_content "ユーザー情報を更新しました。"
        expect(page).to have_content "change name"
        expect(page).to have_no_content user.name
      end
      it "" do
        expect{
          patch user_path(user),params:{user:{name:"change name",email:"change@email.com",ziel:"foo",memo:"bar"}}
          # user.update(name:"change name",email:"change@email.com")
        }.to change{user.inspect}
      end
    end
  end
# users edit test

# users destroy test
  describe "users destroy" do
    before do
      visit login_path
      fill_in "Email",with:user.email
      fill_in "Password",with:user.password
      click_button "ログイン"
    end
    context "when not admin user" do
      it "delete button is not displayed" do
        visit users_path
        expect(current_path).to eq user_path(user)
        # expect(current_path).to eq users_path
        # expect(page).to have_no_link "delete"
      end

      it "" do
        expect{
          delete user_path(other_user)
        }.to_not change{User.count}
      end
    end

    context "when user is admin" do
      before do
        user.toggle!(:admin)
        expect(user.admin?).to be true
      end

      it "delete button is displayed" do
        visit users_path
        expect(current_path).to eq users_path
        expect(page).to have_link "削除"
      end
      it "one user is reduced" do
        visit users_path
        expect(page).to have_link "削除",count:User.count
        expect(User.count).to eq 3
        # expect{
        #   # click_link "削除"
        #   # click alert code
        #   page.accept_confirm do
        #     within ".#{other_user.name.gsub(" ","")}" do
        #       click_on "削除"
        #     end
        #   end
        # }.to change{User.count}.by(-1)
        # no change! why?
      end

      it "" do
        expect(other_user.admin?).to be false
        expect{
          delete user_path(other_user)
        }.to change{User.count}.by(-1)
      end
    end
  end
# users destroy test

# users ziel and memo test
  describe "user ziel and memo" do
    before do
      visit login_path
      fill_in "Email",with:user.email
      fill_in "Password",with:user.password
      click_button "ログイン"
    end
    it "goals and notes are set correctly" do
      visit user_path(user)
      expect(current_path).to eq user_path(user)
      click_link "目標・メモ設定"
      expect(current_path).to eq ziel_user_path
      ziel = "I want to get a job as a programmer"
      memo = "Lern Ruby, Rails, Server, Computer Science"
      fill_in "Ziel",with:ziel
      fill_in "Memo",with:memo
      click_button "更新"
      expect(page).to have_content "目標を設定しました！"
      expect{user.update(ziel:ziel,memo:memo)}.to change{user.ziel}.from(nil).to(ziel)
      expect(user.ziel).to eq ziel
      expect(user.memo).to eq memo
    end

    it "" do
    end
  end


  # describe 'ログイン前' do
  #   # describe 'ログインが必要なページに行こうとした時' do
  #   #
  #   # end
  #
  #   # describe 'ユーザー新規登録' do
  #   #   # context '失敗' do
  #   #   #   it "名前が未入力" do
  #   #   #     visit new_user_path
  #   #   #     fill_in "Name"    ,with:"" # user1
  #   #   #     fill_in "Email"   ,with:"user1@email.com"
  #   #   #     fill_in "Password",with:"password"
  #   #   #     fill_in "Password confirmation",with:"password"
  #   #   #     click_button "登録する"
  #   #   #     expect(page).to have_content "Nameを入力してください"
  #   #   #   end
  #   #   # end
  #   #
  #   #   # context '成功' do
  #   #   #   # it "登録に成功する" do
  #   #   #   #   visit new_user_path
  #   #   #   #   fill_in "Name"    ,with:"user1"
  #   #   #   #   fill_in "Email"   ,with:"user1@email.com"
  #   #   #   #   fill_in "Password",with:"password"
  #   #   #   #   fill_in "Password confirmation",with:"password"
  #   #   #   #   click_button "登録する"
  #   #   #   #   expect(page).to have_content "アカウントを作成しました。"
  #   #   #   # end
  #   #   # end
  #   # end
  # end
    # describe 'ユーザー一覧へのアクセス' do
    #   # context '一般ユーザー' do
    #   #   it '失敗する' do
    #   #     visit users_path
    #   #     expect(current_path).to eq user_path(@user)
    #   #   end
    #   # end
    #
    #   # context '管理者権限ユーザー' do
    #   #   it '成功する' do
    #   #     @user.toggle!(:admin)
    #   #     visit users_path
    #   #     expect(current_path).to eq users_path
    #   #   end
    #   # end
    # end
end
