require "helper"
require "kerala"

module Kerala
  class TestSchemaRegister < Minitest::Test

    def setup
      Kerala::Config.schemas = {}
    end

    def test_returns_unknown_schema_when_not_registered
      schema = SchemaRegister.fetch(2)

      assert_instance_of UnknownSchema, schema
    end

    class TestKnownSchema < Minitest::Test

      def setup
        Kerala::Config.schemas = {
          1 => "fake.avsc"
        }
      end

      def test_retrieves_schema
        schema = fetch_fake_schema(1)

        assert_instance_of Schema, schema
      end

      def test_assigns_id
        schema = fetch_fake_schema(1)

        assert_equal schema.id, 1
      end

      def test_assigns_value
        schema = fetch_fake_schema(1)

        refute_nil schema.value
      end

      def fetch_fake_schema(id)
        File.stub :read, fake_schema do
          @schema = SchemaRegister.fetch(id)
        end
        @schema
      end

      def fake_schema
        %q|{ "name": "fake", "type": "string" }|
      end
    end
  end
end
