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

    it 'has / can read merchants' do
      se
      expect(SalesEngine.merchants.length).to eq(475)
    end

    it 'has / can read items' do
      se
      expect(SalesEngine.items.length).to eq(1367)
    end

    it 'has #find_by_id' do
      se
      expect(SalesEngine.find_by_id('263395237')).to eq true
    end
  end
end
