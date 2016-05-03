require "helper"
require "kerala"

module Kerala
  class FakeClass; end

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

    def test_fetches_schema_by_objects_class
      schema_register = SchemaRegister.new
      test_schema = Schema.new(1, fake_schema(:name => FakeClass))

      schema_register.register test_schema

      assert_equal 1, schema_register.fetch_for(FakeClass.new).id
    end

    def test_returns_unknown_schema_for_unregistered_class
      schema = SchemaRegister.new.fetch_for(Object.new)

      assert_instance_of UnknownSchema, schema
    end
  end
end
