class CreateRelatedOfTaskAndLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :related_of_task_and_labels do |t|
      t.integer :task_id, null: false
      t.integer :label_id, null: false

      t.timestamps
    end
  end
end
