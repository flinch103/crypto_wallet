class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.float :wage
      t.text :note
      t.integer :status, default: 0
      t.integer :vodiant_id
      t.integer :vodeer_id
      t.integer :arbiter_id
      t.integer :max_vodeer

      t.timestamps
    end
  end
end
