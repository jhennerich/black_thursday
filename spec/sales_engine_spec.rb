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

    xit '#items has / can read item info' do
      SalesEngine.from_csv({:items=> "./data/items.csv",
                            :merchants => "./data/merchants.csv"})
      expect(SalesEngine.items.count).to eq(1367)
#      expect(se[0].count).to eq(1367)
    end
    it '#merchants has / can read merchant info' do
      sales_engine = SalesEngine.from_csv({:items=> "./data/items.csv",
                            :merchants => "./data/merchants.csv"})
      expect(se.merchants.length).to eq(475)
    end

  end
end
