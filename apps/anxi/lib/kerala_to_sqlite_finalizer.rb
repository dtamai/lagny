module Anxi
  class KeralaToSQLFinalizer
    def initialize(metadata, consumer)
      @metadata = metadata
      @consumer = consumer
    end

    def finalize
      @metadata.set(:updated_at, Time.now)
      @metadata.set(:latest_offset, @consumer.offset)
    end
  end
end
