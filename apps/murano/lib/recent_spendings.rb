module Murano
  class RecentSpendings
    def initialize(limit = 10)
      @limit = limit
      @consumer = Kerala::SimpleConsumer.new(
        ENV["KERALA_KAFKA_CONNECTION"], "spending")
    end

    def fetch
      cache = []
      consumer.consume do |event|
        cache.unshift event
        cache.pop if cache.size > limit
      end
      cache
    end

    private

    attr_reader :consumer, :limit
  end
end
