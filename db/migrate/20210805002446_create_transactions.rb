class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :merchant, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.string :card_number
      t.datetime :transaction_date
      t.float :transaction_amount
      t.integer :device_id
      t.boolean :recommendation, default: false
      t.boolean :has_cbk, default: false

      t.timestamps
    end
  end
end
