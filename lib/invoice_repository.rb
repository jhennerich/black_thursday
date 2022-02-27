require_relative 'invoice'
class InvoiceRepository

  def inspect
    "#<\#{self.class} \#{@items.size} rows>"
  end

  def initialize(data)
    @invoices = []
      CSV.foreach(data, headers: true, header_converters: :symbol) do |row| header ||= row.headers
        @invoices << Invoice.new(row)
    end
  end


  def all
    @invoices
  end

  def find_by_id(invoice_id)
    @invoices.find { |invoice| invoice.id == invoice_id}
  end


end
