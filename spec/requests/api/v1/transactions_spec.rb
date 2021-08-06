require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  let(:user) { create(:user) }
  let(:customer) { create(:customer) }
  let(:merchant) { create(:merchant) }
  let(:transaction) { create(:transaction, customer: customer, merchant: merchant) }
  let(:close_transaction) { create(:transaction, customer: customer, merchant: merchant, transaction_date: rand(Time.now - 9.minutes..Time.now).strftime("%FT%T.%L") ) }

  describe "POST" do

    before do
      customer
      merchant
      @headers = {
        'ACCEPT': 'application/json',
        'X-User-Token': user.authentication_token,
        'X-User-Email': user.email
      }
    end

    describe 'Request Not ok' do
      it "Won't accept incorrect token" do
        headers = {
          'ACCEPT': 'application/json',
          'X-User-Token': 'incorrect token',
          'X-User-Email': user.email
        }
  
        transaction_params = attributes_for(:transaction).merge(user_id: customer.id, merchant_id: merchant.id, transaction_id: '123456')
  
        post api_v1_transactions_path, params: transaction_params, headers: headers
  
        expect(response.body).to include_json(
          error: "Your token or email isn't working, please verify the infos !"
        )
      end

      it "don't work if user not filled" do
        transaction_params = attributes_for(:transaction).merge(merchant_id: merchant.id)
  
        post api_v1_transactions_path, params: transaction_params, headers: @headers
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
  
        post api_v1_transactions_path, params: transaction_params, headers: @headers
  
        expect(response.body).to include_json(
          error: "The transaction already exists"
        )
      end
    end

    describe 'Request OK' do
      it "works with complete data" do
        transaction_params = attributes_for(:transaction).merge(user_id: customer.id, merchant_id: merchant.id, transaction_id: '123456')
  
        post api_v1_transactions_path, params: transaction_params, headers: @headers
  
        expect(response.body).to include_json(
          transaction_id: 123456,
          recommendation: 'approve'
        )
      end
  
      it "won´t approve two close transactions" do
        close_transaction
  
        transaction_params = attributes_for(:transaction).merge(user_id: customer.id, merchant_id: merchant.id, transaction_id: '123456')
  
        post api_v1_transactions_path, params: transaction_params, headers: @headers
  
        expect(response.body).to include_json(
          transaction_id: 123456,
          recommendation: 'deny'
        )
      end
  
      it "won't approve if the amount is > 5x the user's average" do
        transaction_1 = create(:transaction, user_id: customer.id, merchant_id: merchant.id, transaction_amount: 200)
        transaction_2 = create(:transaction, user_id: customer.id, merchant_id: merchant.id, transaction_amount: 100)
        transaction_3 = create(:transaction, user_id: customer.id, merchant_id: merchant.id, transaction_amount: 400)
  
        average = (transaction_1.transaction_amount + transaction_2.transaction_amount + transaction_3.transaction_amount) / 3
  
        transaction_params = attributes_for(:transaction).merge(user_id: customer.id, merchant_id: merchant.id, transaction_id: '123456', amout: 6 * average)
  
        post api_v1_transactions_path, params: transaction_params, headers: @headers
  
        expect(response.body).to include_json(
          transaction_id: 123456,
          recommendation: 'deny'
        )
      end
    end
    end

    

  describe "PATCH" do

    before do
      customer
      merchant
      @headers = {
        'ACCEPT': 'application/json',
        'X-User-Token': user.authentication_token,
        'X-User-Email': user.email
      }
    end

    describe "Request OK" do
      it 'Actualize the chargeback status' do
        transaction
        patch api_v1_transactions_path, params: {transaction_id: transaction.id, chargeback: true}, headers: @headers
        expect(response.body).to include_json(
          transaction_id: transaction.id,
          has_cbk: true
        )
      end
    end

    describe "Request Not OK" do
      it "Send message error if Transaction can't be found" do
        transaction
        false_id = transaction.id + 100
        patch api_v1_transactions_path, params: {transaction_id: false_id, chargeback: true}, headers: @headers
        expect(response.body).to include_json(
          error: "Couldn't find Transaction with 'id'=#{false_id}"
        )
      end

      it "Verify chargeback format" do
        transaction
        patch api_v1_transactions_path, params: {transaction_id: transaction.id, chargeback: 'not good'}, headers: @headers
        expect(response.body).to include_json(
          error: "Chargeback isn't good format. Please review the request"
        )
      end
    end
  end
end
