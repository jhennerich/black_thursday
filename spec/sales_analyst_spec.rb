require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'
require_relative '../lib/invoice_repository'
# require_relative '
require_relative 'spec_helper'
require 'pry'

RSpec.describe SalesAnalyst do

  before(:each) do
    se = SalesEngine.from_csv({customers: "./data/customers.csv", invoice_items: "./data/invoice_items.csv", invoices: "./data/invoices.csv", items: "./data/items.csv", merchants: "./data/merchants.csv", transactions: "./data/transactions.csv"})
    @analyst = se.analyst
    # binding.pry
  end

context 'iteration 1' do
  it 'calculates average items per merchant' do
    average_item = @analyst.average_items_per_merchant
    expect(average_item).to eq 2.88
    expect(average_item.class).to be Float
  end

  it 'calculates average items per standard deviation' do
    average_item = @analyst.average_items_per_merchant_standard_deviation
    expect(average_item).to eq 3.26
    expect(average_item.class).to be Float
  end

  it 'returns merchants with high item counts' do
    merchants_with_high_count = @analyst.merchants_with_high_item_count
    expect(merchants_with_high_count.length).to eq 52
    expect(merchants_with_high_count.first.class).to eq Merchant
  end

   it 'returns average price of given merchant' do
     average_price_per_merchant = @analyst.average_item_price_for_merchant(12334105)
     expect(average_price_per_merchant).to eq 16.66
   end

   it 'returns average price for all merchants' do
     average_price_all_merchants = @analyst.average_average_price_per_merchant
     expect(average_price_all_merchants).to eq 350.29
   end

   it 'returns golden items' do
     golden_items = @analyst.golden_items
     expect(golden_items.length).to eq 5
     expect(golden_items.first.class).to eq Item
   end

 end

  context 'iteration 2' do
    it 'calculates average_invoices_per_merchant' do
      expect(@analyst.average_invoices_per_merchant).to eq(10.49)
    end


      it 'calculates average invoices per standard deviation' do
        average_invoices= @analyst.average_invoices_per_merchant_standard_deviation
        expect(average_invoices).to eq 3.29
        expect(average_invoices.class).to be Float
      end

      it 'returns top merchant by invoice count' do
        merchants_with_high_invoice_count = @analyst.top_merchants_by_invoice_count
        expect(merchants_with_high_invoice_count.length).to eq 12
        expect(merchants_with_high_invoice_count.first.class).to eq Merchant
      end

      it 'returns bottom merchant by invoice count' do
        merchants_with_low_invoice_count = @analyst.bottom_merchants_by_invoice_count
        expect(merchants_with_low_invoice_count.length).to eq 4
        expect(merchants_with_low_invoice_count.first.class).to eq Merchant
      end

      it 'returns top days by invoice count' do
        expect(@analyst.top_days_by_invoice_count).to eq ["Wednesday"]
      end

      it 'returns a percentation of an invoice status' do
        pending_percentage = @analyst.invoice_status(:pending)
        expect(pending_percentage).to eq 29.55
      end

    end

      context 'iteration 3' do
        it 'checks whether invoice is paid in full' do
          expect(@analyst.invoice_paid_in_full?(1)).to be true
        end

        it 'calculates the total $ amount of the invoice with corresponding invoice id' do
          expect(@analyst.invoice_total(1)).to eq 21067.77
        end
      end

      context 'iteration 4' do
        it 'calculates the total revenue for a given date' do
            date = Time.parse("2009-02-07")
            expect(@analyst.total_revenue_by_date(date)).to eq 21067.77
        end

        it 'returns the top x merchants ranked by revenue' do
          expect(@analyst.top_revenue_earners(10).length).to eq 10
          expect(@analyst.top_revenue_earners.sample).to be_a Merchant
        end

        it 'returns merchants with pending invoices' do
          expect(@analyst.merchants_with_pending_invoices.length).to eq 

        end
      end
  end
