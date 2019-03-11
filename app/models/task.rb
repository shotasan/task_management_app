class Task < ApplicationRecord
  validates :title, :content, :limit_date, presence: true
  validates :title, length: { maximum: 30 }
  scope :limit_date, -> {order("limit_date")}
  scope :sort_title_and_status, -> (title,status) {where("title LIKE? and status LIKE?", "%#{title}%", "%#{status}%")}
  scope :sorted, -> { order(created_at: :desc) }
end