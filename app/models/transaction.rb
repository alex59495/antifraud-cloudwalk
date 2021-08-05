class Transaction < ApplicationRecord
  belongs_to :merchant
  belongs_to :customer, class_name: "Customer", foreign_key: 'user_id'
end
