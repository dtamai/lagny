module Murano
  class RecentSpendings
    def initialize(limit = 10)
      @limit = limit
    end

    def fetch
      Anxi::DB[:spendings].order_by(:date).last(limit).map do |sp|
        Kerala::AddSpending.new(sp)
      end
    end

    private

    attr_reader :limit
  end
end
