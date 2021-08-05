require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { should belong_to(:customer).class_name('Customer').with_foreign_key('user_id') }
  it { should belong_to(:merchant) }
end
