require "helper"
require "murano"

module Murano
class TestSpendingSerializerCSV < Minitest::Test

  def test_serializes_as_csv
    serialized = SpendingSerializerCSV.new(some_spending).serialize
    row = CSV.parse(
      spending_string,
      headers: true, header_converters: :symbol
    ).first

    assert_equal row, serialized
  end

  def spending_string
    <<-EOL.gsub(/^\s{6}/, "")
      date,currency,value,pay_method,seller,category,tags,description
      2015-11-20,BRL,15.99,cartao credito,boteco,alimentacao,comida,Almoço
    EOL
  end

  def some_spending
    Spending.new.tap do |s|
      s.date = Date.new(2015, 11, 20)
      s.currency = "BRL"
      s.value = 15.99
      s.pay_method = "cartao credito"
      s.seller = "boteco"
      s.category = "alimentacao"
      s.tags = "comida"
      s.description = "Almoço"
    end
  end
end
end
