require 'pry'
require_relative 'repository'
require_relative 'merchant'

class MerchantRepository < Repository
  attr_reader :data, :merchants

  def initialize(data)
    @data = File.readlines data
    @merchants = []
    @data.each_with_index do |line, index|
      next if index == 0
      columns = line.split(",")
      @merchants << Merchant.new({id: columns[0], name: columns[1], created_at: columns[2], updated_at: columns[3]})
    end
    super(@merchants)
  end

  def create(new_name)
    id = @merchants[-1].id + 1
    name = new_name[:name]
    new_merch = Merchant.new({id: id, name: name, created_at: Time.now, updated_at: Time.now})
    @merchants << new_merch
    new_merch
  end

  def update(id, attribute)
    if attribute.keys.include?(:name) == true
      if find_by_id(id) != nil
        merchant = find_by_id(id)
        merchant.name = attribute[:name]
        merchant.updated_at = Time.now
        end
      end
    merchant
  end
 end
