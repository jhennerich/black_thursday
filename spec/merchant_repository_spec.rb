require_relative '../lib/sales_engine'
require_relative '../lib/merchant_repository'
require_relative 'spec_helper'
require 'pry'

RSpec.describe MerchantRepository do

   before(:each) do
     @se = SalesEngine.from_csv({ :items => "./data/items.csv",
                                 :merchants => "./data/merchants.csv"})
     @mr = MerchantRepository.new(@se[1])
   end

  it "exist" do
    expect(@mr).to be_a(MerchantRepository)
  end

  it "holds #all merchant data" do

    expect(@mr.all.count).to eq(475)
  end

  it "#find_by_id finds a merchant by id" do

    id = 12335971
    merchant = @mr.find_by_id(id)
    expect(merchant.id).to eq(id)
    expect(merchant.name).to eq "ivegreenleaves"
  end


end
