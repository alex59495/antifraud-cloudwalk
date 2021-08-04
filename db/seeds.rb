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
  unless User.find_by(id: transac['user_id'])
    u = User.create!(
      id: transac['user_id'],
      name: Faker::Name.name
      )
    p "Create #{u.id} User"
  end

  unless Merchant.find_by(id: transac['merchant_id'])
    m = Merchant.create!(
      id: transac['merchant_id'],
      )
    p "Create #{m.id} Merchant"
  end
end