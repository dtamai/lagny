module Kerala
  class SimpleConsumer
    def initialize(conn_string, topic, acceptable_schema = nil, name="")
      host, port = conn_string.split(":")
      @acceptable_schema = acceptable_schema
      @consumer = Poseidon::PartitionConsumer.new(
        name, host, port, topic, 0, :earliest_offset)
    end

    def consume
      messages = consumer.fetch
      messages.each do |m|
        format, schema_id, payload = m.value.unpack("LLA*")
        schema = schema_for schema_id
        next unless format == Serializer::FORMAT
        next if schema == Schema.unknown

        yield decode(payload, schema)
      end
      nil
    end

    private

    attr_reader :consumer, :acceptable_schema

    def schema_for(schema_id)
      Config.schema_register.fetch(schema_id)
    end

    def decode(payload, schema)
      reader = Avro::IO::DatumReader.new(schema.value, (acceptable_schema || schema).value)
      decoder = Avro::IO::BinaryDecoder.new(StringIO.new(payload))
      attributes = reader.read(decoder)
      schema.event_class.new attributes
    end
  end
end
