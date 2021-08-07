class FraudValidation < ApplicationService
  include TransactionError

  attr_reader :user, :transaction

  def initialize(transaction, user)
    @transaction = transaction
    @user = user
  end

  def call
    no_cbk = Transaction.where(user_id: user.id, has_cbk: true).empty?
    score = ScoreCalculation.call(transaction, user)
    no_cbk && !MultipleCard.call(transaction, user) && score < 10
  end
end
