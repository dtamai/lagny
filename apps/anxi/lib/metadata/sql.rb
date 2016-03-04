module Anxi
  module Metadata
    class Sql
      def initialize(table)
        @table = table
      end

      def get(key)
        @table[:key => key.to_s]&.dig(:value)
      end

      def set(key, value)
        @table.where(:key => key.to_s).tap do |row|
          if row.update(:value => value) == 0
            row.insert(:key => key.to_s, :value => value)
          end
        end
      end
    end
  end
end
