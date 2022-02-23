require './lib/sales_engine'
require './spec/spec_helper'
require 'pry'

RSpec.describe SalesEngine do
let(:se) {SalesEngine.from_csv({:items=> "./data/items.csv", :merchants => "./data/merchants.csv",})}
  describe 'items and merchants' do
    it 'exists' do
      sales_engine = SalesEngine.new

      expect(sales_engine).to be_a(SalesEngine)
    end

    it 'has merchants' do

      expect(se.merchants).to be("./data/merchants.csv")
    end
  end
end
