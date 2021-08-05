class Transaction < ApplicationRecord
  attr_accessor :transaction_id

  belongs_to :merchant
  belongs_to :customer, class_name: "Customer", foreign_key: 'user_id'

  validates :card_number, presence: true
  validates :transaction_date, presence: true
  validates :transaction_amount, presence: true
end
