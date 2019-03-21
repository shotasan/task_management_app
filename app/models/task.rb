class Task < ApplicationRecord
  validates :title, :content, :limit_date, presence: true
  validates :title, length: { maximum: 30 }

  scope :limit_date, -> { order("limit_date") }
  scope :priority, -> { order(priority: :desc) }
  scope :sort_title_and_status, -> (title,status) {where("title LIKE? and status LIKE?", "%#{title}%", "%#{status}%")}
  scope :sorted, -> { order(created_at: :desc) }

  enum priority: { "低" => 0, "中" => 1, "高" => 2 }
  
  has_many :related_of_task_and_labels, dependent: :destroy
  has_many :related_labels, through: :related_of_task_and_labels, source: :label
  accepts_nested_attributes_for :related_of_task_and_labels
  belongs_to :user
end