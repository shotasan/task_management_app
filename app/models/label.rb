class Label < ApplicationRecord
  has_many :related_of_task_and_label, dependent: :destroy
end
