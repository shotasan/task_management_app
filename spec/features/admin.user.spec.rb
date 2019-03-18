require 'rails_helper'

RSpec.describe "ユーザー管理機能", type: :feature do
  let(:user_a) { FactoryBot.build(:user, name: "ユーザーA", email: "a@example.com", password: "password")}

  describe "管理者ユーザーの新規登録のテスト" do
    before do
      visit new_admin_user_path
    end

    context "登録に成功する場合" do
      before do
        fill_in "名前", with: user_a.name
        fill_in "メールアドレス", with: user_a.email
        check "管理者権限"
        fill_in "パスワード", with: user_a.password
        fill_in "パスワード再確認", with: user_a.password
        click_on "アカウント登録"
      end

      it "正常に登録し、一覧画面が表示される" do
        expect(page).to have_content "ユーザー「#{user_a.name}」を登録しました"
        expect(page).to have_content "ユーザー一覧"
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

  describe "ユーザー一覧のテスト" do
    before do
      user_a.save
      visit admin_users_path
    end

    it "ユーザーのidが表示される" do
      expect(page).to have_content user_a.id
    end

    it "ユーザーの名前が表示される" do
      expect(page).to have_content user_a.name
    end

    it "ユーザーのメールアドレスが表示される" do
      expect(page).to have_content user_a.email
    end

    it "ユーザーのタスク数が表示される" do
      expect(page).to have_content user_a.tasks.count
    end

    it "ユーザーの管理者権限の有無が表示される" do
      expect(page).to have_content user_a.admin? ? 'あり' : 'なし'
    end

    it "ユーザーの登録日時が表示される" do
      expect(page).to have_content user_a.created_at
    end

    it "ユーザーの更新日時が表示される" do
      expect(page).to have_content user_a.updated_at      
    end
  end

  describe "ユーザー詳細のテスト" do
    let!(:user_b) { FactoryBot.create(:user) }

    before do
      user_a.save
      user_a.tasks.create(title: "tteesstt", content: "TEST")
      user_b.tasks.create(title: "てすと", content: "ててすすとと")
      task_of_user_a = user_a.tasks
      task_of_user_b = user_b.tasks
    end
    
    context "ユーザーAの詳細画面を表示する場合" do
      before do
        visit admin_user_path(user_a)
      end

      it "ユーザーAの名前が表示される" do
        expect(page).to have_content user_a.name
      end

      it "ユーザーAのメールアドレスが表示される" do
        expect(page).to have_content user_a.email
      end

      it "ユーザーAのタスク数が表示される" do
        expect(page).to have_content user_a.tasks.count
      end

      it "ユーザーAの管理者権限の有無が表示される" do
        expect(page).to have_content user_a.admin? ? 'あり' : 'なし'
      end

      it "ユーザーAの登録日時が表示される" do
        expect(page).to have_content user_a.created_at
      end

      it "ユーザーAの更新日時が表示される" do
        expect(page).to have_content user_a.updated_at
      end

      it "ユーザーAのタスクが表示される" do
        expect(page).to have_content user_a.tasks.first.title
      end

      it "ユーザーBのタスクが表示されない" do
        expect(page).not_to have_content user_b.tasks.first.title
      end
    end
    
    context "ユーザーBの詳細画面を表示する場合" do
      before do
        visit admin_user_path(user_b)
      end

      it "ユーザーBのタスクが表示される" do
        expect(page).to have_content user_b.tasks.first.title
      end

      it "ユーザーAのタスクが表示されない" do
        expect(page).not_to have_content user_a.tasks.first.title
      end
    end
  end

  describe "ユーザー編集のテスト" do
    before do
      user_a.save
      visit edit_admin_user_path(user_a)
      fill_in "パスワード", with: user_a.password
      fill_in "パスワード再確認", with: user_a.password
    end

    it "ユーザーAの名前が入力されている" do
      expect(page).to have_field "名前", with: user_a.name
    end

    it "ユーザーAのメールアドレスが入力されている" do
      expect(page).to have_field "メールアドレス", with: user_a.email
    end

    it "ユーザーAの名前を変更する" do
      fill_in "名前", with: "変更後"
      click_on "アカウント更新"
      expect(page).to have_content "変更後"
    end

    it "ユーザーAのメールアドレスを変更する" do
      fill_in "メールアドレス", with: "change@change.change"
      click_on "アカウント更新"
      expect(page).to have_content "change@change.change"
    end
  end

  describe "ユーザー削除のテスト" do
    before do
      user_a.save
      visit admin_users_path
      click_link "削除"
    end

    it "OKを押すと削除される" do
      page.driver.browser.switch_to.alert.accept
      expect{  }.to change{ User.count }.by(-1)
    end
  end

end