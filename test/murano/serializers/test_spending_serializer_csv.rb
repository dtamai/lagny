require "helper"
require "murano"

module Murano
class TestSpendingSerializerCSV < Minitest::Test

  def test_serializes_as_csv
    serialized = SpendingSerializerCSV.new(some_spending).serialize

    assert_equal spending_string, serialized
  end

  def spending_string
    %Q{2015-11-20,BRL,15.99,cartao credito,boteco,alimentacao,comida,Almoço\n}
  end

  def some_spending
    spending = Spending.new
    spending.date = Date.new(2015, 11, 20)
    spending.currency = "BRL"
    spending.value = 15.99
    spending.pay_method = "cartao credito"
    spending.seller = "boteco"
    spending.category = "alimentacao"
    spending.tags = "comida"
    spending.description = "Almoço"
    spending
  end
end
end
