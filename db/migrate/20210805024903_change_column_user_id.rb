class ChangeColumnUserId < ActiveRecord::Migration[6.1]
  def change
    rename_column :transactions, :customer_id, :user_id
  end
end
