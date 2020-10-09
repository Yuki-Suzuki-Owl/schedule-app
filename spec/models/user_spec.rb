require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  before do
    @user = FactoryBot.create(:user)
  end

  it "名前、メール、パスワードがあれば有効" do
    expect(@user).to be_valid
  end

  it "名前が空なら無効" do
    @user.name = " "
    # expect(@user).to be_valid
    @user.valid?
    expect(@user.errors[:name]).to include("can't be blank")
  end

  it "メールが空なら無効" do
    @user.email = " "
    @user.valid?
    expect(@user.errors[:email]).to include("can't be blank")
  end

  # it "パスワードが空なら無効" do
  #   @user.password = ""
  #   @user.valid?
  #   expect(@user.errors[:password]).to include("can't be blank")
  # end

  it "重複したメールは無効" do
    @otheruser = FactoryBot.build(:user)
    @otheruser.email.upcase!
    @otheruser.valid?
    expect(@otheruser.errors[:email]).to include("has already been taken")
  end

  it "異なるメールなら有効" do
    @otheruser = FactoryBot.build(:user,email:"test@email.com")
    expect(@otheruser).to be_valid
  end

  it ""
  it ""
  it ""
  it ""
  it ""
  it ""
  it ""
end
