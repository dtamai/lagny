module Kerala
  class SimpleConsumer
    def initialize(conn_string, topic, acceptable_schema = nil, name="")
      host, port = conn_string.split(":")
      @acceptable_schema = acceptable_schema
      @consumer = Poseidon::PartitionConsumer.new(
        name, host, port, topic, 0, :earliest_offset)
    end

    def consume
      loop do
        messages = consumer.fetch(:max_wait_ms => 100)
        break if messages.none?

        messages.each do |m|
          format, schema_id, payload = m.value.unpack("LLA*")
          schema = schema_for schema_id
          unless format == Serializer::FORMAT
            Logger.warn "Unexpected message format: '#{format} (offset: #{m.offset})'"
            next
          end
          if schema.unknown?
            Logger.warn "Unknown schema: #{schema_id} (offset: #{m.offset})"
            next
          end

          yield decode(payload, schema)
        end
      end

      nil
    end

    private

    attr_reader :consumer, :acceptable_schema

    def schema_for(schema_id)
      Config.schema_register.fetch(schema_id)
    end

    def decode(payload, schema)
      readers_schema = acceptable_schema || schema
      reader = Avro::IO::DatumReader.new(schema.value, readers_schema.value)
      decoder = Avro::IO::BinaryDecoder.new(StringIO.new(payload))
      attributes = reader.read(decoder)
      schema.event_class.new attributes
    end
  end
end
