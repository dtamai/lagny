module Anxi
  module Schema
    module DSL
      def table(name, &blk)
        ordered_tables << name
        tables[name] = blk
      end

      def create
        ordered_tables.each do |name|
          print "Creating table #{name} ... "
          Anxi::DB.create_table?(name, &tables[name])
          puts "OK"
        end
      end

      def drop
        ordered_tables.reverse_each do |name|
          print "Dropping table #{name} ... "
          Anxi::DB.drop_table?(name)
          puts "OK"
        end
      end

      private

      def ordered_tables
        @ordered_tables ||= []
      end

      def tables
        @tables ||= {}
      end
    end
  end
end
