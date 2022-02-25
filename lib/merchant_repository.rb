require_relative 'sales_engine'
require_relative 'merchant'
class MerchantRepository
  attr_reader :merchant_csv_file

    def initialize(merchant_csv_file)
      @merchants = []
      create_merchants(merchant_csv_file)
    end

    def create_merchants(merchant_csv_file)
      CSV.foreach(merchant_csv_file, headers: true, header_converters: :symbol) do |row| header ||= row.headers
            @merchants << Merchant.new(row)
      end
    end

    def merchants
      @merchants
    end

    def all
      @merchants
    end

    def find_by_id(id)
      @merchants.find do |merchant|
         merchant.id == id
      end
    end
end
