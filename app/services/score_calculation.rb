class ScoreCalculation < ApplicationService

  attr_reader :transaction, :user
  attr_accessor :score

  def initialize(transaction, user)
    @transaction = transaction
    @user = user
    @score = 0
  end

  # Si l'utilisateur a deja réalisé une transaction :
  # < 10 min -> 5 points
  # < 30 min -> 4 points
  # < 1 heure -> 3 points
  # < 6 heures -> 2 points
  # < 1 jour -> 1 points

  # Si montant de la transaction > moyenne des transactions de l'utilisateur :
  # x 5 -> 5 points
  # x 3 -> 3 points
  # x 2 -> 2 points

  def call
    transactions = Transaction.where(user_id: user.id)

    if TransactionTimeVerif.call(transaction, 10.minutes, transactions)
      self.score += 5
    elsif TransactionTimeVerif.call(transaction, 30.minutes, transactions)
      self.score += 4
    elsif TransactionTimeVerif.call(transaction, 1.hour, transactions)
      self.score += 3
    elsif TransactionTimeVerif.call(transaction, 6.hour, transactions)
      self.score += 2
    elsif TransactionTimeVerif.call(transaction, 1.day, transactions)
      self.score += 1
    end

    average_amount_user = CalculAverageAmount.call(user)

    if average_amount_user && transaction.transaction_amount > 5 * average_amount_user
      self.score += 5
    elsif average_amount_user && transaction.transaction_amount > 3 * average_amount_user
      self.score += 3
    elsif average_amount_user && transaction.transaction_amount > 2 * average_amount_user
      self.score += 3
    end
    
    self.score
  end
end