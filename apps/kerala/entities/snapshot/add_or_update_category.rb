module Kerala
  module Snapshot
    class AddOrUpdateCategory < Event
      attribute :category,     String, :default => "unknown".freeze
      attribute :display_name, String, :default => "unknown".freeze
    end
  end
end
