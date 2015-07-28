require "helper"
require "kerala"

module Kerala
  class TestSchemaRegister < Minitest::Test
    def test_returns_unknown_schema_when_not_registered
      schema = SchemaRegister.new.fetch(2)

      assert_instance_of UnknownSchema, schema
    end

    def test_registers_a_new_schema
      schema_register = SchemaRegister.new
      test_schema = Schema.new(1, fake_schema)

      schema_register.register test_schema

      refute_instance_of UnknownSchema, schema_register.fetch(1)
    end

    def fake_schema
      %q|{ "name": "fake", "type": "string" }|
    end
  end
end
