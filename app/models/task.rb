class Task < ApplicationRecord
  validates :title, :content, :limit_date, presence: true
  validates :title, length: { maximum: 30 }

  scope :limit_date_sort, -> { order('limit_date') }
  scope :priority, -> { order(priority: :desc) }
  scope :sort_title_and_status, -> (title,status) {where('title LIKE? and status LIKE?', "%#{title}%", "%#{status}%")}
  scope :sorted, -> { order(created_at: :desc) }
  # 締切超過・締切５日前のタスクを抽出する
  scope :deadline_tasks, -> { where("limit_date <= ?",  Date.current.since(5.days)).order(:limit_date)}
  # 未完了のタスクを抽出する
  scope :incomplete, -> { where.not("status = '完了'")}

  enum priority: {:低 => 0, :中 => 1, :高 => 2 }

  paginates_per 10

  has_many :related_of_task_and_labels, dependent: :destroy
  has_many :related_labels, through: :related_of_task_and_labels, source: :label
  belongs_to :user
  accepts_nested_attributes_for :related_of_task_and_labels
end