# 「FactoryBotを使用します」という記述
FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # （実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを自動で作成します）
  factory :task do
    title { 'Factoryで作ったデフォルトのタイトル１' }
    content { 'Factoryで作ったデフォルトのコンテント１' }
    limit_date { '2019-1-1'}
    status { "完了" }
    priority { "低" }
    user
  end

  factory :second_task, class: Task do
    title { 'ファクトリーで作ったデフォルトのタイトル2' }
    content { 'Factoryで作ったデフォルトのコンテント2' }
    created_at { '2030-1-1'}
    limit_date { '2020-1-1'}
    status { "着手中" }
    priority { "中" }
    user
  end

  factory :third_task, class: Task do
    title { 'Factoryで作ったデフォルトのタイトル3' }
    content { 'Factoryで作ったデフォルトのコンテント3' }
    created_at { '2017-1-1'}
    limit_date { '2021-1-1'}
    status { "未着手" }
    priority { "高" }
    user
  end
end