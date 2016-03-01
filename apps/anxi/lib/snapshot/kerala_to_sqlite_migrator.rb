module Anxi
  module Snapshot
    class KeralaToSQLMigrator
      def initialize(consumer)
        @consumer = consumer
      end

      def migrate
        @consumer.consume do |event|
          byebug
          case event
          when Kerala::Snapshot::AddOrUpdatePile then process_pile event
          else next
          end
        end
      end

      def process_pile(event)
        Anxi::DB.transaction do
          Anxi::DB[:piles]
            .where(:pile => event.pile).tap do |dataset|
            dataset.insert(event.fields) if dataset.update(event.fields) == 0
          end
        end

        nil
      end
    end
  end
end
