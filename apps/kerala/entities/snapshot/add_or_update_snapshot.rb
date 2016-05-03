module Kerala
  module Snapshot
    class AddOrUpdateSnapshot < Event
      attribute :snapshot, String,  :default => "unknown".freeze
      attribute :year,     Integer, :default => 0
      attribute :month,    Integer, :default => 0
      attribute :day,      Integer, :default => 0
    end
  end
end
