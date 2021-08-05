# This will guess the User class
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com" }
    password { 'testtest' }
    sequence(:authentication_token) { |n| "m2_T9AkghFbMYQqc4#{n}--" }
  end
end