module Anxi
  module Snapshot
    class KeralaToSQLMigrator
      def initialize(consumer, writer)
        @consumer = consumer
        @writer = writer
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
            $stderr << ["[#{self.class.name}]", "Error processing",
                        "class=#{event.class}", "attributes=#{event.to_h}", e
                       ].join("\t")
          end
        end
      end

      def process_pile(event)
        @writer.update_or_insert(
          event, :table => :sn_piles,
                 :where => -> { { :pile => event.pile } })
      end

      def process_category(event)
        @writer.update_or_insert(
          event, :table => :sn_categories,
                 :where => -> { { :category => event.category } })
      end

      def process_bucket(event)
        @writer.update_or_insert(
          event, :table => :sn_buckets,
                 :where => -> { { :bucket => event.bucket } })
      end

      def process_snapshot(event)
        @writer.update_or_insert(
          event, :table => :sn_snapshots,
                 :where => -> { { :snapshot => event.snapshot } })
      end
    end
  end
end
