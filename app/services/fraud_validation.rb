class FraudValidation < ApplicationService
  include TransactionError

  attr_reader :user, :transaction

  def initialize(transaction, user)
    @transaction = transaction
    @user = user
  end

  def call
    has_cbk = Transaction.where(user_id: user.id, has_cbk: true).any?
    score = ScoreCalculation.call(transaction, user)
    !has_cbk && score < 5
  end
end
