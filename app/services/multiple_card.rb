# Verify if multiple cards are used by the user the same day with the same merchant

class MultipleCard < ApplicationService
  attr_reader :transaction, :user, :transactions

  def initialize(transaction, user)
    @transaction = transaction
    @user = user
    @transactions = user.transactions
  end

  def call
    return true if more_than_2_cards?

    transactions = transactions_under_1day
    transactions = transactions_from_same_merchant
    transactions = transactions_from_different_cards
    transactions.any?
  end

  private

  def more_than_2_cards?
    transactions.pluck(:card_number).uniq.length > 2
  end

  def transactions_under_1day
    transactions.where('transaction_date BETWEEN ? AND ?', transaction.transaction_date - 1.day, transaction.transaction_date)
  end

  def transactions_from_same_merchant
    transactions.where(merchant_id: transaction.merchant_id)
  end

  def transactions_from_different_cards
    transactions.where.not(card_number: transaction.card_number)
  end
end
