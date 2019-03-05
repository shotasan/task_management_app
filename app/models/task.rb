class Task < ApplicationRecord
  validates :title, :content, presence: true
  validates :title, length: { maximum: 30 }
end
