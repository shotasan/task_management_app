class AddLimitDateToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :limit_date, :date, null: false, default: Date.today 
  end
end
