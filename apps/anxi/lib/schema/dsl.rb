module Anxi
  module Schema
    module DSL
      def table(name, &blk)
        tables[name] = blk
      end

      def create
        tables.each_pair do |name, definition|
          print "Creating table #{name} ... "
          Anxi::DB.create_table?(name, &definition)
          puts "OK"
        end
      end

      def drop
        tables.each_key do |name|
          print "Dropping table #{name} ... "
          Anxi::DB.drop_table?(name)
          puts "OK"
        end
      end

      private

      def tables
        @tables ||= {}
      end
    end
  end
end
