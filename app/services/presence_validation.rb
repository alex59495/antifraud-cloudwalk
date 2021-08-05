class PresenceValidation < ApplicationService
  attr_reader :customer, :merchant

  def initialize(customer, merchant)
    @customer = customer
    @merchant = merchant
  end

  def call
    !customer.nil? && !merchant.nil?
  end
end