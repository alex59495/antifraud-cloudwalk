# This will guess the User class
FactoryBot.define do
  factory :transaction do
    customer
    merchant
    transaction_date { Time.now.strftime("%FT%T.%L") }
    card_number { '434505******9116' }
    sequence(:id) { |x| "234241#{x}".to_i }
    transaction_amount { 100 }
    device_id { 28000 }
  end
end