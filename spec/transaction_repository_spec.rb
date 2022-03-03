require 'csv'
require_relative '../lib/sales_engine'
require_relative '../lib/transaction_repository'
require_relative 'spec_helper'

RSpec.describe TransactionRepository do

  before(:each) do
    se = SalesEngine.from_csv({ customers: "./data/customers.csv", invoice_items: "./data/invoice_items.csv",
       invoices: "./data/invoices.csv", items: "./data/items.csv",
       merchants: "./data/merchants.csv", transactions: "./data/transactions.csv"})
    @transactions = se.transactions
  end

  it "exists" do
    expect(@transactions).to be_a(TransactionRepository)
  end

  it "#find_all_by_credit_card_number" do
     credit_card_number = "4848466917766329"
     expected = @transactions.find_all_by_credit_card_number(credit_card_number)

     expect(expected.length).to eq 1
     expect(expected.first.class).to eq Transaction
     expect(expected.first.credit_card_number).to eq credit_card_number

     credit_card_number = "4848466917766328"
     expected = @transactions.find_all_by_credit_card_number(credit_card_number)

     expect(expected.empty?).to eq true
  end

  it "#find_all_by_result" do

    result = :success
    expected = @transactions.find_all_by_result(result)

     expect(expected.length).to eq 4158
     expect(expected.first.class).to eq Transaction
     expect(expected.first.result).to eq result

     result = :failed
     expected = @transactions.find_all_by_result(result)

     expect(expected.length).to eq 827
     expect(expected.first.class).to eq Transaction
     expect(expected.first.result).to eq result
  end

  it "#update updates a transaction" do
    attributes = {
       :invoice_id => 8,
       :credit_card_number => "4242424242424242",
       :credit_card_expiration_date => "0220",
       :result => "success",
       :created_at => Time.now,
       :updated_at => Time.now
     }
     @transactions.create(attributes)

    original_time = @transactions.find_by_id(4986).updated_at
      attributes = {
        result: :failed
    }
    @transactions.update(4986, attributes)
    expected = @transactions.find_by_id(4986)
    expect(expected.result).to eq :failed
    expect(expected.credit_card_expiration_date).to eq "0220"
    expect(expected.updated_at).to be > original_time
    end
end
