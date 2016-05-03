module Kerala
  class AddOrUpdatePayMethod < Event
    attribute :identifier,   String, :default => "unknown".freeze
    attribute :display_name, String, :default => "unknown".freeze
  end
end
