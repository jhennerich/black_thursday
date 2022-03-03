require_relative 'merchant_repository'
require_relative 'sales_engine'
require_relative 'item_repository'
require_relative 'invoice'
require 'time'
require 'date'
require 'pry'

class SalesAnalyst
attr_reader :item_num, :items, :merchants, :customers, :invoice_items
  def initialize(merchants, items, invoices, invoice_items, customers, transactions)
    @merchants = merchants
    @items = items
    @invoices = invoices
    @invoice_items = invoice_items
    @customers = customers
    @item_num = []
    @transactions = transactions
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

  def average_average_price_per_merchant
    average_price = []
    @merchants.all.each do |merchant|
      average_price << average_item_price_for_merchant(merchant.id)
    end
    average_price_all_merchants = BigDecimal(average_price.sum/average_price.size).round(2)
  end

  def golden_items
    average_item_price = average_average_price_per_merchant
    item_price_sqr_diff = []
    @items.all.each do |item|
      item_price_sqr_diff << (item.unit_price - average_item_price) ** 2
    end
    item_price_standard_dev = BigDecimal(Math.sqrt(item_price_sqr_diff.sum/@items.all.size), 5).round(2)
    golden_item_list = []
    @items.all.each do |item|
      if item.unit_price > 2*item_price_standard_dev + average_item_price
        golden_item_list << item
      end
    end
    golden_item_list
  end

  def average_invoices_per_merchant
    @invoice_num = []
    @merchants.all.each do |merchant|
      @invoice_num << @invoices.find_all_by_merchant_id(merchant.id).length
    end
    @average_invoices_per_merchant = (@invoice_num.sum(0.0)/@invoice_num.size).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    average_invoices_per_merchant
    invoice_num_diff_sqr = []
    @invoice_num.each do |num|
      invoice_num_diff_sqr << (num - @average_invoices_per_merchant) ** 2
    end
    @standard_deviation = (Math.sqrt(invoice_num_diff_sqr.sum / @invoice_num.size)).round(2)
  end

  def top_merchants_by_invoice_count
    average_invoices_per_merchant_standard_deviation
    merchant_with_high_invoice_count = []
    @merchants.all.each do |merchant|
      invoices_per_merchant = @invoices.find_all_by_merchant_id(merchant.id)
        if invoices_per_merchant.length > 2 * @standard_deviation + @average_invoices_per_merchant
          merchant_with_high_invoice_count << @merchants.find_by_id(merchant.id)
        end
      end
      merchant_with_high_invoice_count
  end

  def bottom_merchants_by_invoice_count
    average_invoices_per_merchant_standard_deviation
    merchant_with_low_invoice_count = []
    @merchants.all.each do |merchant|
      invoices_per_merchant = @invoices.find_all_by_merchant_id(merchant.id)
        if invoices_per_merchant.length < @average_invoices_per_merchant - 2 * @standard_deviation
          merchant_with_low_invoice_count << @merchants.find_by_id(merchant.id)
        end
      end
      merchant_with_low_invoice_count
  end

  def top_days_by_invoice_count
    invoice_per_wdays = Hash.new(0)
    @invoices.all.each do |invoice|
      invoice_per_wdays[invoice.created_at.strftime("%A")] +=1
    end
    [invoice_per_wdays.max_by{|k,v| v}[0]]
  end


  def invoice_status(status)
    invoice_status = Hash.new(0)
    @invoices.all.each do |invoice|
      invoice_status[invoice.status] +=1
    end
    ((invoice_status[status].to_f / @invoices.all.count) * 100).round(2)
  end

  def invoice_paid_in_full?(invoice_id)
    transactions = @transactions.find_all_by_invoice_id(invoice_id)
    transactions.any? {|transaction| transaction.result == :success} && transactions != []
  end

  def invoice_total(invoice_id)
    @invoice_items.find_all_by_invoice_id(invoice_id).map{|invoice_item|
         invoice_item.unit_price * invoice_item.quantity}.sum
  end

  def total_revenue_by_date(date)
    invoice_id = @invoices.all.find_all {|invoice| invoice.created_at.to_s[0..9] == date.to_s[0..9]}[0].info[:id].to_i
    invoice_total(invoice_id)
  end


  def top_revenue_earners(x=20)
    merchant_and_revenue = Hash.new(0)
    @merchants.all.each {|merchant|
        invoices_by_merchant = @invoices.find_all_by_merchant_id(merchant.id)
        invoices_by_merchant.each {|invoice| merchant_and_revenue[merchant] += invoice_total(invoice.id) if invoice_paid_in_full?(invoice.id)}
                         }
      top_merchants_and_revenue = merchant_and_revenue.sort_by{|k,v| v}.reverse[0..x-1]
    top_earners = top_merchants_and_revenue.map { |tmr| tmr[0]}
  end


  def merchants_with_pending_invoices
    pending_merchants = []
    pending_invoices = @invoices.all.find_all{|invoice| !invoice_paid_in_full?(invoice.id)}
    pending_invoices.each {|pending_invoice|
      # require 'pry'; binding.pry
      pending_merchants << @merchants.find_by_id(pending_invoice.merchant_id)
      }

    pending_merchants.uniq
  end
end
