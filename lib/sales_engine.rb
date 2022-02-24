require 'csv'
require 'pry'

class SalesEngine
  attr_reader :items, :merchants

  def self.from_csv(argument)

    @items = []
    @items = CSV.read(argument[:items], headers: true, header_converters: :symbol)

    @merchants = []
    @merchants = CSV.read(argument[:merchants], headers: true, header_converters: :symbol)

  end

  def self.merchants
    return @merchants
  end

  def self.items
    return @items
  end

  def self.find_by_id(id)
    result = []
    @items.find_all do |element|
      if element[:id] == id
#        puts "found id #{id}"
        return true
##        result << element
#      binding.pry
      end
    end
#    return result
  end


  # def load_data(data_csv, header)
  #   rows = CSV.read(data_csv, headers: true)
  #     rows.find_all do |element|
  #       if element[header] == name
  #         result << element
  #       end
  #     end
  #   result
  # end

end
