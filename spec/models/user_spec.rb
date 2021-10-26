require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  before do
    @user = FactoryBot.create(:user)
  end

  it "名前、メール、パスワードがあれば有効" do
    @user.valid?
    expect(@user).to be_valid
  end

  it "名前が空なら無効" do
    @user.name = nil
    # expect(@user).to be_valid
    @user.valid?
    expect(@user.errors[:name]).to include("を入力してください")
  end

  it "メールが空なら無効" do
    @user.email = ""
    @user.valid?
    expect(@user.errors[:email]).to include("を入力してください")
  end

  it "パスワードが空なら無効" do
    # user.rbにバリデーション validates :password,presence:true をつけると、他のやつではパスワードを入力していないので、パスワードが入力されていないことでエラーになる
    # 対策＝＞allow_nilでnilをスキップする
    # user情報変更時にパスワードが必要なくなる
    # user新規登録時は has_secure_password が付いてるからok
    # @user.password = "" # error ※パスワードが ”” の時の対処方法 ※
    @user.password = " " # ok
    # @user.password = nil # ok
    @user.valid?
    expect(@user.errors[:password]).to include("を入力してください")
  end

  it "7文字以下のパスワードは無効" do
    @user.password = "a" * 6
    @user.valid?
    expect(@user.errors[:password]).to include("は7文字以上で入力してください")
  end

  it "重複したメールは無効" do
    @otheruser = FactoryBot.build(:user)
    @otheruser.email.upcase!
    # @otheruser.email = "otheruser@email.com"
    @otheruser.valid?
    expect(@otheruser.errors[:email]).to include("はすでに存在します")
  end

  it "異なるメールなら有効" do
    @otheruser = FactoryBot.build(:user,email:"test@email.com")
    expect(@otheruser).to be_valid
  end

  it "不適切なメールアドレスは無効"
  # メールアドレスの正規表現チェック
end
