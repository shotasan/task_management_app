class Label < ApplicationRecord
  has_many :related_of_task_and_labels, dependent: :destroy
  has_many :related_tasks, through: :related_of_task_and_labels, source: :task
end
