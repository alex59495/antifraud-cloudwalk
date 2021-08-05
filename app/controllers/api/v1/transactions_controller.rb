class Api::V1::TransactionsController < Api::V1::BaseController
  before_action :find_transaction, only: [:show, :update]
  before_action :find_customer, :find_merchant, only: [:create]
  acts_as_token_authentication_handler_for User
  protect_from_forgery with: :null_session

  def show; end

  def create
    raise CustomerError unless PresenceValidation.call(customer: @customer)
    raise MerchantError unless PresenceValidation.call(merchant: @merchant)
    raise TransactionAlreadyExists if Transaction.find_by(id: params_transaction_id)

    @transaction = Transaction.new(params_transaction)
    @transaction.recommendation = true if FraudValidation.call(@transaction, @customer)
    @transaction.id = params_transaction_id
    if @transaction.save
      render :show
    else
      render_error
    end
  end

  def update
    if @transaction
      render :show
    else
      render_error
    end
  end

  private

  def params_transaction_id
    params[:transaction_id]
  end

  def find_transaction
    @transaction = Transaction.find(params[:transaction_id])
  end

  def find_merchant
    @merchant = Merchant.find_by(id: params.require(:transaction)[:merchant_id])
  end

  def find_customer
    @customer = Customer.find_by(id: params.require(:transaction)[:user_id])
  end

  def params_transaction
    params.require(:transaction).permit(:user_id, :merchant_id, :card_number, :transaction_date, :transaction_amount, :device_id, :has_cbk)
  end

  def render_error
    render json: { errors: @transaction.errors.full_messages },
      status: :unprocessable_entity
  end
end
