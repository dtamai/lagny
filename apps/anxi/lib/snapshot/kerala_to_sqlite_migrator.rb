module Anxi
  module Snapshot
    class KeralaToSQLMigrator
      def initialize(consumer)
        @consumer = consumer
      end

      def migrate
        @consumer.consume do |event|
          begin
            case event
            when Kerala::Snapshot::AddOrUpdatePile     then process_pile event
            when Kerala::Snapshot::AddOrUpdateCategory then process_category event
            when Kerala::Snapshot::AddOrUpdateBucket   then process_bucket event
            when Kerala::Snapshot::AddOrUpdateSnapshot then process_snapshot event
            else next
            end
          rescue StandardError => e
            $stderr << "[#{self.class.name}]\tError processing\tclass=#{event.class}\tattributes=#{event.to_h}\t#{e}"
          end
        end
      end

      def process_pile(event)
        Anxi::DB.transaction do
          Anxi::DB[:sn_piles]
            .where(:pile => event.pile).tap do |dataset|
            dataset.insert(event.fields) if dataset.update(event.fields) == 0
          end
        end

        nil
      end

      def process_category(event)
        Anxi::DB.transaction do
          Anxi::DB[:sn_categories]
            .where(:category => event.category).tap do |dataset|
            dataset.insert(event.fields) if dataset.update(event.fields) == 0
          end
        end

        nil
      end

      def process_bucket(event)
        Anxi::DB.transaction do
          Anxi::DB[:sn_buckets]
            .where(:bucket => event.bucket).tap do |dataset|
            dataset.insert(event.fields) if dataset.update(event.fields) == 0
          end
        end

        nil
      end

      def process_snapshot(event)
        Anxi::DB.transaction do
          Anxi::DB[:sn_snapshots]
            .where(:snapshot => event.snapshot).tap do |dataset|
            dataset.insert(event.fields) if dataset.update(event.fields) == 0
          end
        end

        nil
      end
    end
  end
end
