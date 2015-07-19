module Kerala
  class Publisher
    attr_reader :name

    def initialize(name, producer)
      @name = name
      @producer = producer
    end

    def publish(event, topic)
      event.header = make_header
      message = serializer_for(event).serialize
      producer.send_message message, topic
    end

    private

    attr_reader :producer

    def make_header
      {
        :publishing_time => Time.now,
        :publisher => name
      }
    end

    def serializer_for(object)
      schema = SchemaRegister.fetch(object.schema_id)
      Serializer.new(object, schema)
    end
  end
end
