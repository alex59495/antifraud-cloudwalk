class Customer < ApplicationRecord
  has_many :transactions, class_name: "Transaction", foreign_key: "user_id"
  has_many :merchants, through: :transactions
end
