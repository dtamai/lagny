module Anxi
  module Metadata
    class Sql
      TABLE_NAME = :__spendings_metadata

      def initialize(conn)
        @table = conn[TABLE_NAME]
      end

      def get(key)
        @table[:key => key.to_s]&.dig(:value)
      end

      def set(key, value)
        @table.where(:key => key.to_s).update(:value => value)
      end
    end
  end
end
