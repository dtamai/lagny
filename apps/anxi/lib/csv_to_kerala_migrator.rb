module Anxi
  class CSVToKeralaMigrator

    SUPPORTED_SCHEMA = 3

    def initialize(file, producer)
      @file = file
      @producer = producer
    end

    def migrate
      csv.each do |line|
        spending = Kerala::AddSpending.new(line)
        spending.cents_from_value(line[:value])
        @producer.send_message("spending", message_for(spending))
      end
    end

    private

    def csv
      options = {
        :headers => true,
        :header_converters => :symbol,
        :return_headers => true
      }
      CSV.new(@file, options).tap(&:shift)
    end

    def schema
      @schema ||= Kerala::Config.schema_register.fetch(SUPPORTED_SCHEMA)
    end

    def message_for(object)
      Kerala::Serializer.new(object, schema).serialize
    end

  end
end
