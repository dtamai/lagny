require "helper"
require "kerala"

module Kerala
  class TestSerializer < Minitest::Test

    class Dummy
      include Virtus.model
      attribute :name, String, default: "dummy"
    end

    def test_message_format_in_first_32_bits
      serializer = Serializer.new(Dummy.new, schema)
      message = serializer.serialize

      format, = message.unpack("L")

      assert_equal Serializer::FORMAT, format
    end

    def test_schema_id_in_next_32_bits
      serializer = Serializer.new(Dummy.new, schema)
      message = serializer.serialize

      _, schema_id = message.unpack("LL")

      assert_equal 9, schema_id
    end

    def test_payload_in_the_remaining
      serializer = Serializer.new(Dummy.new(name: "foo"), schema)
      message = serializer.serialize

      _, _, payload = message.unpack("LLA*")

      assert_match /foo/, payload
    end

    def schema
      Schema.new(
        9,
        %q|{
        "name": "dummy",
        "type": "record",
        "fields": [ {"type":"string","name":"name"}]}|)
    end

  end
end
