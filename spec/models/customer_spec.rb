require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should have_many(:transactions).class_name('Transaction').with_foreign_key('user_id') }
  it { should have_many(:merchants) }
end
