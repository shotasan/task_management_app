require 'rails_helper'

RSpec.describe User, type: :model do
  let (:user_a) { FactoryBot.build(:user) }

  it "名前、メールアドレス、パスワードが入力されていれば有効な状態であること" do
    expect(user_a).to be_valid
  end

  context "名前についてのテスト" do

    it "名前が無ければ無効な状態であること" do
      user_a.name = nil
      user_a.valid?
      expect(user_a.errors.full_messages.first).to include("名前を入力してください")
    end

    it "名前が30文字以内なら有効な状態であること" do
      user_a.name = "a" * 30
      expect(user_a).to be_valid
    end

    it "名前が30文字より多いなら無効な状態であること" do
      user_a.name = "a" * 31
      user_a.valid?
      expect(user_a.errors.full_messages.first).to include("名前は30文字以内で入力してください")
    end
  end

  context "メールアドレスについてのテスト" do

    it "メールアドレスが無ければ無効な状態であること" do
      user_a.email = nil
      user_a.valid?
      expect(user_a.errors.full_messages.first).to include("メールアドレスを入力してください")    
    end

    it "重複したメールアドレスなら無効な状態であること" do
      user_a.save
      test_user = User.new(name: "test_user_2", email: user_a.email, password: "test")
      test_user.valid?
      expect(test_user.errors.full_messages.first).to include("メールアドレスはすでに存在します")
    end

    it "メールアドレスには@と.が含まれていないと無効な状態であること" do
      user_a.email = "test"
      user_a.valid?
      expect(user_a.errors.full_messages.first).to include("メールアドレスは不正な値です")    
    end
  end

  context "パスワードについてのテスト" do

    it "パスワードが無ければ無効な状態であること" do
      user_a.password = nil
      user_a.valid?
      expect(user_a.errors.full_messages.first).to include("パスワードを入力してください")
    end

    it "パスワードが6文字未満だと無効な状態であること" do
      user_a.password = "a" * 5
      user_a.valid?
      expect(user_a.errors.full_messages.first).to include("パスワードは6文字以上で入力してください")
    end
  end
end
