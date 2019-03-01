class Task < ApplicationRecord
  validates :title, :content, presence: true
end
