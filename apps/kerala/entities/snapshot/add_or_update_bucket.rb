module Kerala
  module Snapshot
    class AddOrUpdateBucket < Event
      def schema_id
        10
      end

      attribute :bucket,       String, :default => "unknown".freeze
      attribute :display_name, String, :default => "unknown".freeze
      attribute :category,     String, :default => "unknown".freeze
      attribute :pile,         String, :default => "unknown".freeze
    end
  end
end
