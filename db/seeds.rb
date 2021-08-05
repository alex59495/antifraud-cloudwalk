# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

User.destroy_all
Merchant.destroy_all
p "Destroyed the database"

CSV.foreach('./transactional-sample.csv', headers: true, encoding:'utf-8', col_sep: ",") do |row|
  # Create a hash for each MOA with the header of the CSV file
  transac = row.to_h
  unless Customer.find_by(id: transac['user_id'])
    u = Customer.create!(
      id: transac['user_id']
    )
  end

  unless Merchant.find_by(id: transac['merchant_id'])
    m = Merchant.create!(
      id: transac['merchant_id']
    )
  end

  unless Transaction.find_by(id: transac['transaction_id'])
    t = Transaction.create!(
      id: transac['transaction_id'],
      merchant_id: transac['merchant_id'],
      customer_id: transac['user_id'],
      card_number: transac['card_number'],
      transaction_date: transac['transaction_date'],
      transaction_amount: transac['transaction_amount'],
      device_id: transac['device_id']
    )
  end
end
p "Data created !"

User.create(email: 'test@test.com', password: 'testtest', authentication_token: 'm2_T9AkghFbMYQqc46--')
