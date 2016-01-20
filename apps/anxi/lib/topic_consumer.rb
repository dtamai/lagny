module Anxi
  class TopicConsumer

    def initialize(conn_string, topic)
      host, port = conn_string.split(":")
      @consumer = Poseidon::PartitionConsumer.new(
        "anxi", host, port, topic, 0, :earliest_offset)
    end

    def consume
      messages = consumer.fetch
      messages.each do |m|
        format, schema_id, payload = m.value.unpack("LLA*")
        next unless format == Kerala::Serializer::FORMAT

        msg_schema = schema_for schema_id
        decoded = decode(msg_schema, payload)
        yield msg_schema.event_class.new(decoded) if decoded
      end
      nil
    end

    private

    attr_reader :consumer

    def schema_for(schema_id)
      Kerala::Config.schema_register.fetch(schema_id)
    end

    def decode(schema, payload)
      reader = Avro::IO::DatumReader.new(
        schema.value, schema_for(CSVWriter::SUPPORTED_SCHEMA).value)
      decoder = Avro::IO::BinaryDecoder.new(StringIO.new(payload))
      reader.read(decoder)
    rescue
      nil
    end

  end
end
