module Kerala
  module Snapshot
    class AddOrUpdatePile < Event
      attribute :pile,         String, :default => "unknown".freeze
      attribute :display_name, String, :default => "unknown".freeze
    end
  end
end
