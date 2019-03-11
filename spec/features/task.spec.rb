# このrequireで、Capybaraなどの、Feature Specに必要な機能を使用可能な状態にしています
require 'rails_helper'

# このRSpec.featureの右側に、「タスク管理機能」のように、テスト項目の名称を書きます（do ~ endでグループ化されています）
RSpec.feature "タスク管理機能", type: :feature do
  # scenario（itのalias）の中に、確認したい各項目のテストの処理を書きます。
  background do
    # あらかじめタスク一覧のテストで使用するためのタスクを二つ作成する

    # backgroundの中に記載された記述は、そのカテゴリ内（feature "タスク管理機能", type: :feature do から endまでの内部）
    # に存在する全ての処理内（scenario内）で実行される
    # （「タスク一覧のテスト」でも「タスクが作成日時の降順に並んでいるかのテスト」でも、background内のコードが実行される）
    FactoryBot.create(:task)
    FactoryBot.create(:second_task)
    FactoryBot.create(:third_task)
  end

  scenario "タスク一覧のテスト" do
    # tasks_pathにvisitする（タスク一覧ページに遷移する）
    visit tasks_path
    # have_contentされているか？（含まれているか？）ということをexpectする（確認・期待する）テストを書いている
    expect(page).to have_content :task
    expect(page).to have_content :second_task
  end

  scenario "タスク作成のテスト" do
    visit new_task_path
    fill_in "タイトル", with: "Test"
    fill_in "内容", with: "testtest"
    fill_in "締め切り", with: Date.current
    click_on "登録する"
    expect(page).to have_content Date.current
  end

  scenario "タスク詳細のテスト" do
    # 詳細のテストで使用するためのタスクを作成する
    Task.create!(id: 1, title: 'test_task_01', content: 'testtesttest')
    # 詳細ページへ遷移
    visit task_path(id: 1)
    # 詳細ページに、作成したはずのデータがhave_contentされているか
    expect(page).to have_content 'testtesttest'
  end

  scenario "タスクが作成日時の降順に並んでいるかのテスト" do
  # ここにテスト内容を記載する
    @tasks = Task.all.order(created_at: :desc)
    visit tasks_path
    expect(@tasks[0].created_at > @tasks[1].created_at).to be true
  end

  scenario "タスク一覧画面で終了期限でソートするを押した際に、タスクが締め切り日の昇順で並んでいるかのテスト" do
    visit tasks_path
    click_on "終了期限でソートする"
    @tasks = Task.all.order("limit_date")
    expect(@tasks[0].limit_date < @tasks[1].limit_date).to be true
  end

  scenario "タスク一覧画面でタイトル検索欄を入力後、検索ボタンを押した際に、検索した用語を含むタスクが並んでいるかのテスト" do
    visit tasks_path
    fill_in "task_title", with: "テスト"
    click_on "Search"
    expect(page).to have_content "テスト"
  end

  scenario "タスク一覧画面でstatusを選択し、検索ボタンを押した際に、検索した用語を含むタスクが並んでいるかのテスト" do
    visit tasks_path
    select "完了", from: "task_status"
    click_on "Search"
    expect(page).to have_content "完了"
  end
end