# 「FactoryBotを使用します」という記述
FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # （実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを自動で作成します）
  factory :task do
    title { 'Factoryで作ったデフォルトのタイトル１' }
    content { 'Factoryで作ったデフォルトのコンテント１' }
    limit_date { '2020-4-1'}
    status { "完了" }
    priority { "低" }
  end

  # 作成するテストデータの名前を「second_task」とします
  # （存在しないクラス名の名前をつける場合、オプションで「このクラスのテストデータにしてください」と指定します）
  factory :second_task, class: Task do
    title { 'Factoryで作ったデフォルトのタイトル２' }
    content { 'Factoryで作ったデフォルトのコンテント２' }
    limit_date { '2019-2-28'}
    priority { "高" }
  end

  factory :third_task, class: Task do
    title { 'テスト3' }
    content { 'Factoryで作ったデフォルトのコンテント3' }
    limit_date { '2021-8-28'}
    status { "着手中" }
    priority { "中" }
  end
end