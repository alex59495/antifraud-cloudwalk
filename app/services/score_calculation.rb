class ScoreCalculation < ApplicationService

  attr_reader :transaction, :user, :transactions
  attr_accessor :score

  def initialize(transaction, user)
    @transaction = transaction
    @user = user
    @score = 0
    @transactions = user.transactions
  end

  def call
    self.score += ScoreByTime.call(transaction, transactions)
    average_amount_user = CalculAverageAmount.call(user)
    self.score += ScoreByAmount.call(transaction, average_amount_user) if average_amount_user
    self.score
  end
end