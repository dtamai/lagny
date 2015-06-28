module Kerala
  class Schema

    attr_reader :id, :value

    def initialize(id, definition)
      @id = id
      @value = Avro::Schema.parse(definition)
    end

    def self.unknown
      UnknownSchema.instance
    end

  end

  class UnknownSchema < Schema
    include Singleton

    def initialize
      @id = nil
      @value = nil
    end
  end
end
