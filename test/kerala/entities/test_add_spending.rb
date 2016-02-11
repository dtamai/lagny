require "helper"
require "kerala"

module Kerala
  class TestAddSpending < Minitest::Test
    def test_conversion_value_to_cents
      assert_equal 100, spending_with_value(1).cents
      assert_equal 342, spending_with_value(3.42).cents
      assert_equal 6955, spending_with_value("69.55").cents
      assert_equal 4030, spending_with_value("40.30").cents
      assert_equal 1, spending_with_value(0.01).cents
    end

    def spending_with_value(value)
      sp = AddSpending.new
      sp.cents_from_value(value)
      sp
    end
  end
end
