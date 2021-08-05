class TransactionTimeVerif < ApplicationService

  attr_reader :transaction, :time, :transactions

  def initialize(transaction, time, transactions)
    @transaction = transaction
    @time = time
    @transactions = transactions
  end

  def call
    transactions.where('transaction_date < ?', transaction.transaction_date - time).any?
  end
end
