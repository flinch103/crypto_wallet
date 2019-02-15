class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.string :address, null: false
      t.references :user, foreign_key: true, index: true
      t.float :balance, default: 0.0

      t.timestamps null: false
    end
  end
end
