require 'pry'
require './lib/sales_engine'
#require './spec/spec_helper'

se = SalesEngine.from_csv({
  :items     => "./data/items.csv",
  :merchants => "./data/merchants.csv",
})

SalesEngine.find_by_id('263395237')
