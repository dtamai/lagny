require "helper"

module Kerala
  class TestPublisher < Minitest::Test

    def test_adds_header_information
      schema_register = schema_register_with(dummy_schema)
      producer = mock_producer :send_message => [nil, [String, String]]
      publisher = Publisher.new("dummy", producer, schema_register)
      evt = Dummy.new

      Time.stub :now, Time.at(12_345_678) do
        publisher.publish(evt, "")
      end
      header = evt.header

      assert_equal 12_345_678_000, header.publishing_time
      assert_equal "dummy", header.publisher
    end

    def test_forwards_message_to_producer
      schema_register = schema_register_with(dummy_schema)
      producer = mock_producer :send_message => [nil, ["topic", String]]
      publisher = Publisher.new("", producer, schema_register)

      publisher.publish(Dummy.new, "topic")

      producer.verify
    end

    def schema_register_with(schema)
      sr = SchemaRegister.new
      sr.register(schema)
      sr
    end

    def mock_producer(options = {})
      mock = Minitest::Mock.new
      mock.expect :send_message, *options.delete(:send_message)
      mock
    end

    class Dummy < Event
      def schema_id
        1
      end
    end

    def dummy_schema
      Schema.new(
        1,
        %q|{
        "name": "Dummy",
        "type": "record",
        "fields": [
            { "name": "header", "type":
              { "type": "record", "name": "headerType", "fields": [
                { "name": "publishing_time", "type": "long" },
                { "name": "publisher", "type": "string" }
              ]}
            }
        ]}|)
    end
  end
end
