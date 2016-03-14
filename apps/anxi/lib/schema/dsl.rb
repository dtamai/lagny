module Anxi
  module Schema
    module DSL
      def table(name, &blk)
        tables[name] = blk
      end

      def create
        tables.each_pair do |name, definition|
          Anxi::DB.create_table?(name, &definition)
        end.keys
      end

      def drop
        tables.each_key do |name|
          Anxi::DB.drop_table?(name)
        end.keys
      end

      private

      def tables
        @tables ||= {}
      end
    end
  end
end
