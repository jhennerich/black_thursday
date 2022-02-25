require 'pry'
require_relative '../lib/sales_engine'
require_relative 'spec_helper'

RSpec.describe SalesEngine do
  let(:se) {SalesEngine.from_csv({:items=> "./data/items.csv", :merchants => "./data/merchants.csv"})}
  describe 'items and merchants' do
    it 'exists' do
      sales_engine = SalesEngine.new
      expect(sales_engine).to be_a(SalesEngine)
    end

    it '#items has / can read item info' do
      SalesEngine.from_csv({:items=> "./data/items.csv",
                            :merchants => "./data/merchants.csv"})
      expect(SalesEngine.items.count).to eq(1367)
#      expect(se[0].count).to eq(1367)
    end
    it '#merchants has / can read merchant info' do
      expect(SalesEngine.merchants.count).to eq(475)
#      expect(se[1].count).to eq(475)
    end

  end
end
