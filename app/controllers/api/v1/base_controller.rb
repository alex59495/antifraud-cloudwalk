class Api::V1::BaseController < ApplicationController
  include TransactionError
  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from TransactionError::TransactionAlreadyExists, with: :transaction_already_exists
  rescue_from TransactionError::CustomerError, with: :customer_error
  rescue_from TransactionError::MerchantError, with: :merchant_error
  rescue_from TransactionError::FraudError, with: :fraud_error
  rescue_from TransactionError::FraudErrorScore, with: :fraud_error_score


  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def transaction_already_exists(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def customer_error(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def merchant_error(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def fraud_error(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def fraud_error_score(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
