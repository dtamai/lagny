module Kerala
  class Schema

    attr_reader :id, :value, :event_class

    def initialize(id, definition)
      @id = id
      @value = Avro::Schema.parse(definition)
      @event_class = Kernel.const_get event_name
    end

    def self.unknown
      UnknownSchema.instance
    end

    def unknown?
      false
    end

    private

    def event_name
      "#{value.namespace}::#{value.name}"
    end

  end

  class UnknownSchema < Schema
    include Singleton

    def initialize
      @id = nil
      @value = nil
      @event_class = Event
    end

    def unknown?
      true
    end
  end
end
