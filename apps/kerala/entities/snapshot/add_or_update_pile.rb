module Kerala
  module Snapshot
    class AddOrUpdatePile < Event
      def schema_id
        8
      end

      attribute :pile,         String, :default => "unknown".freeze
      attribute :display_name, String, :default => "unknown".freeze
    end
  end
end
