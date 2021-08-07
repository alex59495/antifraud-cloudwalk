class ScoreByAmount < ApplicationService

  attr_reader :transaction, :average


  # key/value
  # average multiplicator / number of point adding to the score

  AVERAGE_MULTIPLICATOR = {
    "5" => 10,
    "3" => 5,
    "2" => 2
  }

  def initialize(transaction, average)
    @transaction = transaction
    @average = average
  end

  def call
    AVERAGE_MULTIPLICATOR.select { |k, v| transaction.transaction_amount / average > k.to_i }.values.max.to_i
  end
end
