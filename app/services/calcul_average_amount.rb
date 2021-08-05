class CalculAverageAmount < ApplicationService

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    array_amounts_user = Transaction.where(user_id: user.id, recommendation: true).pluck(:transaction_amount)
    array_amounts_user.sum / array_amounts_user.length
    # array_amounts_user.reduce { |acc, val| acc + val } / array_amounts_user.length
  end
end
