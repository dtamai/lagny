require "helper"
require "kerala"

module Kerala
  class TestSchema < Minitest::Test
    def test_infers_class_from_metadata
      schema_definition = fake_schema(
        :name => "DefGhj",
        :namespace => "Abc"
      )
      schema = Schema.new(1, schema_definition)

      assert_equal Abc::DefGhj, schema.event_class
    end

    class TestUnknownSchema < Minitest::Test
      def test_is_a_schema
        assert_kind_of Schema, Schema.unknown
      end

      def test_value_is_nil
        assert_nil Schema.unknown.value
      end
    end

    module ::Abc
      class DefGhj; end
    end
  end
end
