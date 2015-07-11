module Murano
  class Spending

    attr_accessor :date,
      :currency,
      :value,
      :pay_method,
      :seller,
      :category,
      :tags,
      :description

    def cents
      (Float(self.value)*100).round
    end

  end
end
