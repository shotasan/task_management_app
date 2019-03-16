require 'rails_helper'

RSpec.describe Task, type: :model do
 
    let!(:first_task) { FactoryBot.create(:task) }
    let!(:second_task) { FactoryBot.create(:second_task) }
    let!(:third_task) { FactoryBot.create(:third_task, status: "完了")}

  context "バリデーションのテスト" do

    it "titleとcontentに内容が記載されていれば有効な状態であること" do
      expect(first_task).to be_valid
    end
  
    it "titleが無ければ無効な状態であること" do
      first_task.title = nil
      first_task.valid?
      expect(first_task.errors.full_messages.first).to include("タイトルを入力してください")
    end
  
    it "contentが空なら無効な状態であること" do
      first_task.content = nil
      first_task.valid?
      expect(first_task.errors.full_messages.first).to include("内容を入力してください")
    end
  end

  context "scopeのテスト" do

    it "limit_dateメソッドでlimit_dateの昇順が取得される" do
      tasks = Task.all.limit_date
      expect(tasks[0].limit_date < tasks[1].limit_date).to be true
    end

    it "priorityメソッドでpriorityの降順が取得される" do
      tasks = Task.all.priority
      expect(tasks.all? { |t| tasks.first.priority >= t.priority}).to be true
    end
  
    it "sort_title_and_statusメソッドでtitleまたはstatusの特定のレコードが取得される" do
      search_result_title = Task.sort_title_and_status("ファクトリー","")
      expect(search_result_title).to include (second_task)
      search_result_status = Task.sort_title_and_status("","完了")
      expect(search_result_status).to include first_task, third_task
    end
  
    it "sortedメソッドでcreated_atの降順が取得される" do
      tasks = Task.all.sorted
      expect(tasks.all? { |t| tasks.first.created_at >= t.created_at}).to be true
    end
  end
end