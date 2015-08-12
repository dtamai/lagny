module Anxi
  class KeralaToSQLMigrator

    SUPPORTED_SCHEMA = 2

    def initialize(writer, consumer)
      @writer = writer
      @consumer = consumer
    end

    def migrate
      @consumer.consume do |msg|
        @writer.write(Kerala::AddSpending.new(msg))
      end
    end
  end
end
