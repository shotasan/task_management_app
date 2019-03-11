require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    FactoryBot.create(:task)
    FactoryBot.create(:second_task)
    FactoryBot.create(:third_task)
  end

  it "titleが空ならバリデーションが通らない" do
    task = Task.new(title: '', content: '失敗テスト')
    expect(task).not_to be_valid
  end

  it "contentが空ならバリデーションが通らない" do
    # ここに内容を記載する
    task = Task.new(title: '失敗テスト', content: '')
    expect(task).not_to be_valid
  end

  it "titleとcontentに内容が記載されていればバリデーションが通る" do
    task = Task.new(title: '成功テスト', content: '成功テスト')
    expect(task).to be_valid
  end

  it "limit_dateメソッドでlimit_dateの昇順が取得される" do
    tasks = Task.all.limit_date
    expect(tasks[0].limit_date < tasks[1].limit_date).to be true
  end

  it "sort_title_and_statusメソッドでtitleまたはstatusの特定のレコードが取得できる" do
    tasks = Task.sort_title_and_status("１","")
    expect(tasks.first.title).to include "１"
    tasks = Task.sort_title_and_status("","完了")
    expect(tasks.first.status).to include "完了"
  end

  it "sortedメソッドでcreated_atの降順が取得される" do
    tasks = Task.all.sorted
    expect(tasks[0].created_at > tasks[1].created_at).to be true
  end
end