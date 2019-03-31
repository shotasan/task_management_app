class ChangeLimitDateDefaultOnTasks < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tasks, :limit_date, from: "2019-03-06", to: " "
  end
end