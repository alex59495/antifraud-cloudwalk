class Api::V1::BaseController < ApplicationController
  include TransactionError
  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from TransactionError::TransactionAlreadyExists, with: :transaction_already_exists
  rescue_from TransactionError::CustomerEmpty, with: :customer_empty
  rescue_from TransactionError::MerchantEmpty, with: :merchant_empty
  rescue_from TransactionError::TransactionEmpty, with: :transaction_empty
  rescue_from TransactionError::ChargebackFormatError, with: :chargeback_format


  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def transaction_already_exists(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def customer_empty(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def merchant_empty(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def transaction_empty(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def chargeback_format(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
