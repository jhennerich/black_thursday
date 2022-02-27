require_relative 'merchant_repository'
require_relative 'sales_engine'
require_relative 'item_repository'
require 'pry'

class SalesAnalyst
attr_reader :item_num, :items, :merchants
  def initialize(merchants, items)
    @merchants = merchants
    @items = items
    @item_num = []
    @standard_deviation = 0
  end


  def average_items_per_merchant
    @merchants.all.each do |merchant|
      @item_num << @items.find_all_by_merchant_id(merchant.id).length
    end
    @average_items_per_merchant = (@item_num.sum(0.0)/@item_num.size).round(2)
  end


  def average_items_per_merchant_standard_deviation
    average_items_per_merchant
    item_num_diff_sqr = []
    @item_num.each do |num|
      item_num_diff_sqr << (num - @average_items_per_merchant) ** 2
    end
    @standard_deviation = (Math.sqrt(item_num_diff_sqr.sum / @item_num.size)).round(2)
  end


  def merchants_with_high_item_count
    average_items_per_merchant_standard_deviation
    merchant_with_high_count = []
    @merchants.all.each do |merchant|
      items_per_merchant = @items.find_all_by_merchant_id(merchant.id)
        if items_per_merchant.length > @standard_deviation + @average_items_per_merchant
          merchant_with_high_count << @merchants.find_by_id(merchant.id)
        end
      end
      merchant_with_high_count
  end
  def average_item_price_for_merchant(merchant_id)
    item_price = []
    @items.find_all_by_merchant_id(merchant_id).each do |item|
      item_price << item.unit_price
    end
    average_item_price_by_merchant = BigDecimal(item_price.sum/item_price.size).round(2)

  end

end
