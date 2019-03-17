require 'rails_helper'

RSpec.describe "ユーザー管理機能", type: :feature do
  let(:user_a) { FactoryBot.build(:user, name: "ユーザーA", email: "a@example.com", password: "password")}

  describe "ユーザーの新規登録のテスト" do
    before do
      visit new_user_path
    end

    context "登録に成功する場合" do
      before do
        fill_in "名前", with: user_a.name
        fill_in "メールアドレス", with: user_a.email
        fill_in "パスワード", with: user_a.password
        fill_in "パスワード再確認", with: user_a.password
        click_on "アカウント登録"
      end

      it "正常に登録し、一覧画面が表示される" do
        expect(page).to have_content "登録に成功しました"
        expect(page).to have_content "一覧"
      end
    end

    context "登録に失敗する場合" do
      before do
        user_a.save
      end
      
      it "登録ずみのメールアドレスを使用すると警告が表示される" do
        fill_in "メールアドレス", with: user_a.email
        click_on "アカウント登録"
        expect(page).to have_selector ".alert-warning"
      end

      it "名前だけ入力すると警告が表示される" do
        fill_in "名前", with: user_a.name
        click_on "アカウント登録"
        expect(page).to have_selector ".alert-warning"
      end

      it "メールアドレスだけ入力すると警告が表示される" do
        fill_in "メールアドレス", with: user_a.email
        click_on "アカウント登録" 
        expect(page).to have_selector ".alert-warning"
      end

      it "パスワードだけ入力すると警告が表示される" do
        fill_in "パスワード", with: user_a.password
        click_on "アカウント登録" 
        expect(page).to have_selector ".alert-warning"
      end

      it "パズワード再確認だけ入力すると警告が表示される" do
        fill_in "パスワード再確認", with: user_a.password
        click_on "アカウント登録" 
        expect(page).to have_selector ".alert-warning"
      end
    end
  end
    
  describe "ユーザのログインのテスト" do
    before do
      user_a.save
      visit new_session_path
    end

    context "ログインに成功する場合" do
      before do
        fill_in "メールアドレス", with: user_a.email
        fill_in "パスワード", with: user_a.password
        click_on "ログインする"
      end
      
      it "正常にログインし、一覧画面が表示される" do
        expect(page).to have_content "ログインしました"
        expect(page).to have_content "一覧"
      end
    end

    context "ログインに失敗する場合" do
      it "メールアドレスだけ入力すると警告が表示される" do
        fill_in "メールアドレス", with: user_a.email
        click_on "ログインする"
        expect(page).to have_selector ".alert-danger"
      end

      it "パスワードだけ入力すると警告が表示される" do
        fill_in "パスワード", with: user_a.password
        click_on "ログインする"
        expect(page).to have_selector ".alert-danger"
      end

      it "誤ったメールアドレスを入力すると警告が表示される" do
        fill_in "メールアドレス", with: "test@test.com"
        fill_in "パスワード", with: user_a.password
        click_on "ログインする"
        expect(page).to have_selector ".alert-danger"        
      end

      it "誤ったパスワードを入力すると警告が表示される" do
        fill_in "メールアドレス", with: user_a.email
        fill_in "パスワード", with: "test"
        click_on "ログインする"
        expect(page).to have_selector ".alert-danger"        
      end
    end
  end
end