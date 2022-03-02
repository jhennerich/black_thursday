require 'time'
require 'bigdecimal'

class Invoice
  attr_accessor :info

  def initialize(info)
    @info = info
  end

  def id
    @info[:id].to_i
  end

  def customer_id
    @info[:customer_id].to_i
  end

  def merchant_id
    @info[:merchant_id].to_i
  end

  def status
    @info[:status].to_sym
  end

  def created_at
    Time.parse(@info[:created_at]).utc
  end

  def updated_at
    Time.parse(@info[:updated_at]).utc
  end
end
