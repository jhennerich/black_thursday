require 'csv'
require 'pry'
require_relative '../lib/merchant_repository'

class SalesEngine
#  attr_reader :items, :merchants
  def initialize()
    @merchant_array = []
    @items_array = []
  end

  def self.from_csv(argument)
    argument.each do |key, value|
      if key == :merchants
        @merchants_array = MerchantRepository.new(value)
        return @merchants_array
      elsif key == :items
#        @items_array = ItemsRepository.new(value)
#        return @items_array
      end
    end
  end
###
# Need to move to ItemsRepository
#    CSV.foreach(argument[:items], headers: true, header_converters: :symbol) do |row| header ||= row.headers
#        @items << Item.new(row)
#      end
end
