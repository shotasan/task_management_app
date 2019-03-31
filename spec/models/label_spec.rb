require 'rails_helper'

RSpec.describe Label, type: :model do

  context "バリデーションのテスト" do

    it "tittleが30文字以内で入力されているなら有効な状態であること" do
      label = Label.create(title: "a" * 30)
      expect(label).to be_valid
      expect(Label.all).to include label
    end
    
    it "titleが30文字以上なら無効な状態であること" do
      label = Label.create(title: "a" * 31)
      label.valid?
      expect(label.errors.full_messages.first).to include("ラベル名は30文字以内で入力してください")
    end

    it "titleが無ければ無効な状態であること" do
      label = Label.create(title: "")
      label.valid?
      expect(label.errors.full_messages.first).to include("ラベル名を入力してください")
    end
  end
end
