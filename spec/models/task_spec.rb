# frozen_string_literal: true

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
        tasks = Task.all.limit_date_sort
        expect(tasks[0].limit_date < tasks[1].limit_date).to be true
      end

      it "priorityメソッドでpriorityの降順が取得される" do
        tasks = Task.all.priority
        expect(tasks.all? { |t| tasks.first.priority >= t.priority}).to be true
      end

      it "sort_title_and_statusメソッドで検索するtitleに一致するタスクが取得される" do
        task = Task.sort_title_and_status("ファクトリー", "")
        expect(task).to include second_task
      end

      it "sort_title_and_stastuメソッドで検索するstatusに一致するタスクが取得される" do
        task = Task.sort_title_and_status("","完了")
        expect(task).to include first_task, third_task
      end

      it "sortedメソッドでcreated_atの降順が取得される" do
        tasks = Task.all.sorted
        expect(tasks.all? { |t| tasks.first.created_at >= t.created_at}).to be true
      end


      it "deadline_tasksメソッドで締め切りを超過したタスクと締め切りまで５日以内のタスクが取得される" do
        over_deadline_task = FactoryBot.create(:task, limit_date: Date.current.ago(5.days))
        near_deadline_task = FactoryBot.create(:task, limit_date: Date.current.since(5.days))
        still_deadline_task = FactoryBot.create(:task, limit_date: Date.current.since(6.days))
        tasks = Task.deadline_tasks
        expect(tasks).to include over_deadline_task, near_deadline_task
        expect(tasks).not_to include still_deadline_task
      end
  end
end
