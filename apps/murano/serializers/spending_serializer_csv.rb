module Murano
  class SpendingSerializerCSV
    require "csv"

    attr_reader :spending

    def self.headers
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

    def initialize(spending)
      @spending = spending
    end

    def serialize
      CSV::Row.new(self.class.headers, fields)
    end

    private

    def fields
      [
        spending.date.to_s,
        spending.currency,
        sprintf("%.2f", spending.cents/100.0),
        spending.pay_method,
        spending.seller,
        spending.category,
        spending.tags,
        spending.description
      ]
    end

  end
end
