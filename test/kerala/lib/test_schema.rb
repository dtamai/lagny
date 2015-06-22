require "helper"
require "kerala"

module Kerala
  class TestSchema < Minitest::Test

    class TestUnknownSchema < Minitest::Test
      def test_is_a_schema
        assert_kind_of Schema, Schema.unknown
      end

      def test_value_is_nil
        assert_nil Schema.unknown.value
      end
    end

  end
end
