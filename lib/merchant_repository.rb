require_relative 'sales_engine'
class MerchantRepository
  attr_reader :merchant_array

    def initialize(merchant_array)
      @merchant_array = merchant_array
    end

    def all
      @merchant_array
    end

    def find_by_id(id)
      @merchant_array.find do |merchant|
         merchant.id == id
      end
    end
end
