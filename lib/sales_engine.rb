require 'csv'
require 'pry'
require_relative '../lib/merchant_repository'

class SalesEngine
  attr_reader :items, :merchants
  def initialize()
    @merchant_array = []
    @items_array = []
  end

  def self.from_csv(list_of_repos)
    if list_of_repos.include?(:merchants)
        @merchants_array = MerchantRepository.new(list_of_repos[:merchants])
        return @merchants_array
    end

    if list_of_repos.include?(:items)
#        @items_array = ItemsRepository.new(list_of_repos[:items])
#        return @merchants_array
    end
  end

#  def merchants
#      @merchants_array
#    end
###
# Need to move to ItemsRepository
#    CSV.foreach(argument[:items], headers: true, header_converters: :symbol) do |row| header ||= row.headers
#        @items << Item.new(row)
#      end
end
