module Kerala
  class Serializer
    include Functions

    FORMAT = 1

    def initialize(object, schema)
      @object = object
      @io = StringIO.new("", "wb+")
      @encoder = Avro::IO::BinaryEncoder.new io
      @writer = Avro::IO::DatumWriter.new schema.value
      @schema = schema
    end

    def serialize
      writer.write(attributes, encoder)
      [FORMAT, schema.id, io.string].pack("LLA*")
    end

    private

    attr_reader :object, :io, :encoder, :writer, :schema

    def attributes
      fn(:hash_recursion, fn(:stringify_keys!)).call(object.attributes)
    end

  end
end
