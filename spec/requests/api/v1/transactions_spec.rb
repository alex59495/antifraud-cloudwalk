require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  let(:user) { create(:user) }
  let(:customer) { create(:customer) }
  let(:merchant) { create(:merchant) }
  let(:close_transaction) { create(:transaction, customer: customer, merchant: merchant, transaction_date: rand(Time.now - 9.minutes..Time.now).strftime("%FT%T.%L") ) }

  describe "POST" do

    before do
      customer
      merchant
    end

    it "Won't accept incorrect token" do
      headers = {
        'ACCEPT': 'application/json',
        'X-User-Token': 'incorrect token',
        'X-User-Email': user.email
      }

      transaction_params = attributes_for(:transaction).merge(user_id: customer.id, merchant_id: merchant.id, transaction_id: '123456')

      post api_v1_transactions_path, params: { transaction: transaction_params }, headers: headers

      expect(response.body).to include_json(
        error: "Your token or email isn't working, please verify the infos !"
      )
    end
    
    it "works with complete data" do
      headers = {
        'ACCEPT': 'application/json',
        'X-User-Token': user.authentication_token,
        'X-User-Email': user.email
      }

      transaction_params = attributes_for(:transaction).merge(user_id: customer.id, merchant_id: merchant.id, transaction_id: '123456')

      post api_v1_transactions_path, params: { transaction: transaction_params }, headers: headers

      expect(response.body).to include_json(
        transaction_id: 123456,
        recommendation: 'approve'
      )
    end

    it "won´t approve two close transactions" do
      headers = {
        'ACCEPT': 'application/json',
        'X-User-Token': user.authentication_token,
        'X-User-Email': user.email
      }

      close_transaction

      transaction_params = attributes_for(:transaction).merge(user_id: customer.id, merchant_id: merchant.id, transaction_id: '123456')

      post api_v1_transactions_path, params: { transaction: transaction_params }, headers: headers

      expect(response.body).to include_json(
        transaction_id: 123456,
        recommendation: 'deny'
      )
    end

    it "don't work if user not filled" do
      headers = {
        'ACCEPT': 'application/json',
        'X-User-Token': user.authentication_token,
        'X-User-Email': user.email
      }

      transaction_params = attributes_for(:transaction).merge(merchant_id: merchant.id)

      post api_v1_transactions_path, params: { transaction: transaction_params }, headers: headers
      expect(response.body).to include_json(
        error: "User field isn't filled or doesn't exist, please correct the request"
      )
    end

    it "Won't create a new instance of Transaction if the id already exists" do
      headers = {
        'ACCEPT': 'application/json',
        'X-User-Token': user.authentication_token,
        'X-User-Email': user.email
      }

      create(:transaction, id: '123456')
      transaction_params = attributes_for(:transaction).merge(merchant_id: merchant.id, user_id: customer.id, transaction_id: '123456')

      post api_v1_transactions_path, params: { transaction: transaction_params }, headers: headers

      expect(response.body).to include_json(
        error: "The transaction already exists"
      )
    end
  end
end
