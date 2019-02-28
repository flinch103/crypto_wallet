class CreateTasks < ActiveRecord::Migration[5.2]
  enable_extension 'pgcrypto' unless extensions.include?('pgcrypto')
  enable_extension "uuid-ossp" unless extensions.include?('uuid-ossp')
  def change
    create_table :tasks, id: :uuid do |t|
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
