require "helper"
require "kerala"

module Kerala
  class TestSchemaRegister < Minitest::Test

    class TestKnownSchema < Minitest::Test
      def setup
        Kerala::Config.schemas = {
          schema_id => filename
        }
      end

      def fetch_fake_schema(id)
        File.stub :read, fake_schema do
          @schema = SchemaRegister.fetch(id)
        end
        @schema
      end

      def test_retrieves_schema
        schema = fetch_fake_schema(schema_id)

        assert_instance_of Schema, schema
      end

      def test_assigns_id
        schema = fetch_fake_schema(schema_id)

        assert_equal schema.id, schema_id
      end

      def test_assigns_value
        schema = fetch_fake_schema(schema_id)

        refute_nil schema.value
      end

      def schema_id
        1
      end

      def filename
        "fake.avsc"
      end

      def fake_schema
        %q|{ "name": "fake", "type": "string" }|
      end
    end

    def test_returns_unknown_schema_when_not_registered
      schema = SchemaRegister.fetch(unknown_schema)

      assert_instance_of UnknownSchema, schema
    end

    def unknown_schema
      2
    end

  end
end
