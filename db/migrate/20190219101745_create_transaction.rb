class CreateTransaction < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :tx_hex, null: false
      t.integer :status
      t.boolean :sent
      t.float :amount
      t.integer :tx_type
      t.references :wallet, foreign_key: true, index: true
      t.uuid :task_id, foreign_key: true, index: true

      t.timestamps null: false
    end
  end
end
