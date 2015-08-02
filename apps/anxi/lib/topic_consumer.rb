module Anxi
  class TopicConsumer

    def initialize(conn_string, topic)
      host, port = conn_string.split(":")
      @consumer = Poseidon::PartitionConsumer.new(
        "anxi", host, port, topic, 0, 0)
    end

    def consume
      messages = consumer.fetch
      messages.each do |m|
        format, schema_id, payload = m.value.unpack("LLA*")
        next unless format == Kerala::Serializer::FORMAT

        yield decode(schema_id, payload)
      end
      nil
    end

    private

    attr_reader :consumer

    def schema_for(schema_id)
      Kerala::Config.schema_register.fetch(schema_id).value
    end

    def decode(schema_id, payload)
      reader = Avro::IO::DatumReader.new(
        schema_for(schema_id), schema_for(CSVWriter::SUPPORTED_SCHEMA))
      decoder = Avro::IO::BinaryDecoder.new(StringIO.new(payload))
      reader.read(decoder)
    end

  end
end
