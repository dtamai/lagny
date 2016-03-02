module Kerala
  module Snapshot
    class AddOrUpdateCategory < Event
      def schema_id
        9
      end

      attribute :category,     String, :default => "unknown".freeze
      attribute :display_name, String, :default => "unknown".freeze
    end
  end
end
