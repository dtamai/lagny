require "helper"

module Kerala
  class TestPublisher < Minitest::Test
    class Dummy < Event
      def schema_id
        1
      end
    end

    def test_adds_header_information
      producer = mock_producer :send_message => [nil, [String, String]]
      publisher = Publisher.new("dummy", producer)
      evt = Dummy.new

      with_fake_schema_register(schema) do
        Time.stub :now, Time.at(12_345_678) do
          publisher.publish(evt, "")
        end
      end
      header = evt.header

      assert_equal 12_345_678_000, header.publishing_time
      assert_equal "dummy", header.publisher
    end

    def test_forwards_message_to_producer
      producer = mock_producer :send_message => [nil, [String, "topic"]]
      publisher = Publisher.new("", producer)

      with_fake_schema_register(schema) do
        publisher.publish(Dummy.new, "topic")
      end

      producer.verify
    end

    def mock_producer(options = {})
      mock = Minitest::Mock.new
      mock.expect :send_message, *options.delete(:send_message)
      mock
    end

    def with_fake_schema_register(schema)
      SchemaRegister.stub :fetch, schema do
        yield
      end
    end

    def schema
      Schema.new(
        1,
        %q|{
        "name": "dummy",
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
