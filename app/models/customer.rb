class Customer < ApplicationRecord
  has_many :transactions
  has_many :merchants, through: :transactions
end
