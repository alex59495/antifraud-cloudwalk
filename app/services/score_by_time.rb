class ScoreByTime < ApplicationService

  attr_reader :transaction, :transactions

  # key / value
  # minutes / pond
  # If the was X transactions under Y minutes we calculate : score += X * pond (where pond is the hash value and Y is the hash key)

  # For example
  # We ponderate the number of transacations that the user already did under 10 minutes by 5, between 10 and 30 minutes by 3 etc...

  # If a user did 3 transacations under 10 minutes, 2 transations between 10 and 30 min and 1 between 6 hours and 1 day. The score will be : 3 * 5 + 2 * 3 + 1 * 1 = 22
  TIME_POND = {
    10.to_s => 5,
    30.to_s => 3,
    60.to_s => 2,
    360.to_s => 1.5,
    1440.to_s => 1
  }.freeze

  def initialize(transaction, transactions)
    @transaction = transaction
    @transactions = transactions
  end

  def call
    arr = []
    TIME_POND.each_with_index do |(k, v), index|
      previous = index - 1 < 0 ? 0 : TIME_POND.keys[index - 1].to_i
      arr << transactions.where('transaction_date BETWEEN ? AND ?', transaction.transaction_date - k.to_i.minutes, transaction.transaction_date - previous.minutes).count * v
    end
    arr.sum
  end
end
