class TransactionTimeVerif < ApplicationService

  attr_reader :transaction, :time, :transactions

  def initialize(transaction, time, transactions)
    @transaction = transaction
    @time = time
    @transactions = transactions
  end

  def call
    transactions.where('transaction_date BETWEEN ? AND ?', transaction.transaction_date - time, transaction.transaction_date).any?
  end
end
