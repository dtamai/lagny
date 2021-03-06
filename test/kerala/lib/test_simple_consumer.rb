require "helper"
require "kerala"

module Kerala
  class SimpleConsumerTest < Minitest::Test
    def test_yields_event_instance
      register_dummy_schema
      message = Message.new(Dummy.new(:field => "..."), dummy_schema)

      Poseidon::PartitionConsumer.stub(:new, fake_poseidon(message)) do
        consumer = SimpleConsumer.new("topic")
        consumer.consume do |event|
          @event = event
        end
      end

      assert_instance_of ::Dummy, @event

      restore_original_schema
    end

    def test_ignores_unknown_message_format
      message = WrongFormatMessage.new

      Poseidon::PartitionConsumer.stub(:new, fake_poseidon(message)) do
        consumer = SimpleConsumer.new("topic")
        consumer.consume do |_event|
          flunk "Consumer can't yield an event from unknown format"
        end
      end

      pass
    end

    def test_ignores_unknown_schema
      message = Message.new(Dummy.new, unknown_schema)

      Poseidon::PartitionConsumer.stub(:new, fake_poseidon(message)) do
        consumer = SimpleConsumer.new("topic")
        consumer.consume do |_event|
          flunk "Consumer can't yield an event from unknown schema"
        end
      end

      pass
    end

    Dummy = Class.new do
      include Virtus.model
      attribute :field, String, :default => "o.O"
    end

    FakePoseidon = Class.new do
      def initialize(messages)
        @messages = messages
      end

      def fetch(*_args)
        values, @messages = @messages, []
        values
      end
    end

    Message = Struct.new(:object, :schema) do
      def value
        Serializer.new(object, schema).serialize
      end

      def offset
        1
      end
    end

    WrongFormatMessage = Class.new do
      def value
        [49, 49, "BAD"].pack("LLA*")
      end

      def offset
        -1
      end
    end

    def fake_poseidon(*messages)
      FakePoseidon.new(messages)
    end

    def dummy_schema
      @dummy_schema ||= Schema.new(99, fake_schema(:name => "Dummy"))
    end

    def unknown_schema
      Schema.new(49, fake_schema)
    end

    def register_dummy_schema
      original_cache = Config.schema_register.instance_variable_get :@cache
      @original_cache = original_cache.dup
      Config.schema_register.register dummy_schema
    end

    def restore_original_schema
      Config.schema_register.instance_variable_set :@cache, @original_cache
    end
  end
end
