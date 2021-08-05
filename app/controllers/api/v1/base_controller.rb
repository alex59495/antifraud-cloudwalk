class Api::V1::BaseController < ApplicationController
  include TransactionError
  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from TransactionError::TransactionAlreadyExists, with: :transaction_already_exists

  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def transaction_already_exists(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
