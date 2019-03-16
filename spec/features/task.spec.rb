# このrequireで、Capybaraなどの、Feature Specに必要な機能を使用可能な状態にしています
require 'rails_helper'
# RSpec.feature
RSpec.describe "タスク管理機能", type: :feature do
  let(:user_a) { FactoryBot.create(:user, name: "ユーザーA", email: "a@example.com")}
  let(:user_b) { FactoryBot.create(:user, name: "ユーザーB", email: "b@example.com")}
  let!(:task_a) { FactoryBot.create(:task, title: "Aの最初のタスク", limit_date: '2019-1-1', priority: "中", user: user_a)}
  let!(:task_b) { FactoryBot.create(:task, title: "Bの最初のタスク", user: user_b)}
  let!(:task_c) { FactoryBot.create(:task, title: "Aの2番目のタスク", limit_date: "2020-1-1", priority: "高", user: user_a)}
  let!(:task_d) { FactoryBot.create(:task, title: "Aの3番目のタスク", limit_date: "2021-1-1", priority: "低", user: user_a)}

  before do
    visit login_path
    fill_in "メールアドレス", with: login_user.email
    fill_in "パスワード", with: login_user.password
    click_on "ログインする"
  end

  describe "タスク一覧のテスト" do
    context "ユーザーAがログインしているとき" do
      let(:login_user) { user_a }
      
      it "ユーザーAが作成したタスクが表示される" do
        # 作成済みのタスクが画面上に表示される
        expect(page).to have_content "最初のタスク"
      end

      it "登録が最新のタスクが先に表示される(作成日時の降順）" do
        visit tasks_path
        within ".table-body" do
          task_titles = all(".task-title").map(&:text)
          expect(task_titles).to eq %w(Aの3番目のタスク Aの2番目のタスク Aの最初のタスク)
        end
      end

      it "「終了期限でソートする」を押した際に、タスクが締め切り日の昇順で表示される" do
        visit tasks_path
        click_on "終了期限でソートする"
        within ".table-body" do
          task_titles = all(".task-title").map(&:text)
          expect(task_titles).to eq %w(Aの最初のタスク Aの2番目のタスク Aの3番目のタスク)          
        end
      end

      it "一覧画面でタイトル検索欄を入力後、Searchボタンを押すと、検索した用語を含むタスクが表示される" do
        visit tasks_path
        fill_in "task_title", with: task_a.title
        click_on "Search"
        expect(page).to have_content task_a.title
      end

      it "一覧画面で状態を選択し、Searchボタンを押すと、選択した状態に該当しないタスクが表示されない" do
        visit tasks_path
        select "完了", from: "task_status"
        click_on "Search"
        within ".table" do
          expect(page).not_to have_content "未着手"
        end
      end

      it "一覧画面で「優先度でソートする」を押した際に、タスクが優先度の降順で表示される" do
        visit tasks_path
        click_on "優先度でソートする"
        within ".table-body" do
          task_titles = all(".task-title").map(&:text)
          expect(task_titles).to eq %w(Aの2番目のタスク Aの最初のタスク Aの3番目のタスク)          
        end
      end
    end

    context "ユーザーBがログインしているとき" do
      let(:login_user) { user_b }

      it "ユーザーAが作成したタスクが表示されない" do
        expect(page).not_to have_content "Aの最初のタスク"
      end
    end
  end

  describe "タスク新規作成機能のテスト" do
    let (:login_user) { user_a }

    before do
      visit new_task_path
      fill_in "タイトル", with: task_name
      fill_in "内容", with: task_content
      click_on "登録する"
    end
    
    context "新規作成画面でタイトルと内容を入力したとき" do
      let(:task_name) {"新規作成のテストを書く"}
      let(:task_content) {"新規作成のテストを書いてみたテスト"}
      it "正常に登録される" do
        expect(page).to have_selector ".alert-success"
      end
    end

    context "新規作成画面でタイトルを入力しなかったとき" do
      let(:task_name) {""}
      let(:task_content) {"新規作成のテストを書いてみたテスト"}
      
      it "警告が表示される" do
        within "#error_expanation" do
          expect(page).to have_content "タイトルを入力してください"
        end
      end
    end

    context "新規作成画面で内容を入力しなかったとき" do
      let(:task_name) {"新規作成のテストを書く"}
      let(:task_content) {""}

      it "警告が表示される" do
        within "#error_expanation" do
          expect(page).to have_content "内容を入力してください"
        end
      end
    end
  end
  
  describe "タスク詳細のテスト" do
    context "ユーザーAがログインしているとき" do
      let(:login_user) { user_a }

      before do
        visit task_path(task_a)
      end

      it "ユーザーAが作成したタスクが表示される" do
        expect(page).to have_content "最初のタスク"
      end

      it "ユーザーBが作成したタスクが表示されない" do
        expect(page).not_to have_content "Bの最初のタスク"
      end

      it "ユーザーBの詳細画面に遷移するとエラー画面が表示される" do
        visit task_path(task_b)
        expect(page.status_code).to eq 404
      end
    end
  end
end