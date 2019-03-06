class Task < ApplicationRecord
  validates :title, :content, :limit_date, presence: true
  validates :title, length: { maximum: 30 }
end
