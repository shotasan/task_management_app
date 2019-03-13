class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.text :email, null: false
      
      t.timestamps
    end
  end
end
