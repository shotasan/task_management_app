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
  end

  scenario "タスク一覧のテスト" do
    # tasks_pathにvisitする（タスク一覧ページに遷移する）
    visit tasks_path
    # have_contentされているか？（含まれているか？）ということをexpectする（確認・期待する）テストを書いている
    expect(page).to have_content :task
    expect(page).to have_content :second_task
  end

  scenario "タスク作成のテスト" do
    # new_task_pathにvisitする（タスク登録ページに遷移する）
    # 1.ここにnew_task_pathにvisitする処理を書く
    visit new_task_path

    # 「タスク名」というラベル名の入力欄と、「タスク詳細」というラベル名の入力欄に
    # タスクのタイトルと内容をそれぞれfill_in（入力）する
    # 2.ここに「タスク名」というラベル名の入力欄に内容をfill_in（入力）する処理を書
    fill_in "タイトル", with: "Test"
    # 3.ここに「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
    fill_in "内容", with: "testtest"

    # 「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）
    # 4.「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理を書く
    click_on "登録する"

    # clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
    # （タスクが登録されたらタスク詳細画面に遷移されるという前提）
    # 5.タスク詳細ページに、テストコードで作成したはずのデータ（記述）がhave_contentされているか（含まれているか）を確認（期待）するコードを書く
    expect(page).to have_content 'testtest'
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
end