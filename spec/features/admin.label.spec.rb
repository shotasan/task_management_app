require 'rails_helper'

RSpec.describe "ラベル管理機能", type: :feature do
  let(:admin_user) { FactoryBot.create(:user, name: "admin_user", admin: true)}
  let(:task) { FactoryBot.create(:task)}
  before do
    visit new_session_path
    fill_in "メールアドレス", with: admin_user.email
    fill_in "パスワード", with: admin_user.password
    click_on "ログインする"
    visit admin_labels_path
  end

  describe "一覧表示機能のテスト" do
    before do
      FactoryBot.create(:label, title: "ラベルラベルラベル")
      visit admin_labels_path
    end
    it "登録ずみのラベルが一覧に表示される" do
      within ".table-body" do
        expect(page).to have_content "ラベルラベルラベル"
      end
    end

  end

  describe "ラベルの新規登録機能のテスト" do
    
    describe "新規登録が成功する場合" do
  
      before do
      fill_in "label_title", with: "ラベル１"
      click_on "登録する"
      end
  
      it "新規ラベルの登録ができること" do
        expect(page).to have_content "ラベル１を追加しました"
      end
  
      it "ラベルを登録するとラベル一覧に表示されること" do
        within ".table-body" do
          expect(page).to have_content "ラベル１"
        end
      end
    end
  
    describe "新規登録が失敗する場合" do
  
      it "空欄のまま登録するとエラーメッセージが表示されること" do
        click_on "登録する"
        expect(page).to have_content "ラベル名を入力してください"
      end
  
      it "30文字以上を入力して登録するとエラーメッセージが表示されること" do
        fill_in "label_title", with: "a" * 31
        click_on "登録する"
        expect(page).to have_content "ラベル名は30文字以内で入力してください"
      end
    end
  end

  describe "その他のテスト" do
    before do
      task.related_labels.create(title: "テスト")
      visit admin_labels_path
    end

    it "タスクにラベルをつけるとタスクの数が増加すること" do
      expect(page).to have_content task.related_labels.count
    end

    it " ラベルを削除できること" do
      click_on "削除"
      expect(page).to have_content "テストを削除しました"
    end
  end

end