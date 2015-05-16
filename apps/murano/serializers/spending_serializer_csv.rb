module Murano
  class SpendingSerializerCSV
    require "csv"

    attr_reader :spending

    def initialize(spending)
      @spending = spending
    end

    def serialize
      CSV::Row.new(headers, fields)
    end

    private

    def headers
      [
        :date,
        :currency,
        :value,
        :pay_method,
        :seller,
        :category,
        :tags,
        :description
      ]
    end

    def fields
      [
        spending.date.to_s,
        spending.currency,
        sprintf("%.2f", spending.value),
        spending.pay_method,
        spending.seller,
        spending.category,
        spending.tags,
        spending.description
      ]
    end

  end
end
