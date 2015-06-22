module Kerala
  class Schema

    attr_reader :value

    def initialize(definition)
      @value = Avro::Schema.parse(definition)
    end

    def self.unknown
      UnknownSchema.instance
    end

  end

  class UnknownSchema < Schema
    include Singleton

    def initialize
      @value = nil
    end
  end
end
