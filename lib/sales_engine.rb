require 'csv'
require 'pry'
require_relative '../lib/merchant'
require_relative '../lib/item'

class SalesEngine
  attr_reader :items, :merchants

  def self.from_csv(argument)
    @items = []
    CSV.foreach(argument[:items], headers: true, header_converters: :symbol) do |row| header ||= row.headers
        @items << Item.new(row)
      end
    @merchants = []
    CSV.foreach(argument[:merchants], headers: true, header_converters: :symbol) do |row| header ||= row.headers
        @merchants << Merchant.new(row)
      end
    [@items, @merchants]
  end

  def self.items
    @items
  end

  def self.merchants
    @merchants
  end
end
