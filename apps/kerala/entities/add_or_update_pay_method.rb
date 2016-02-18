module Kerala
  class AddOrUpdatePayMethod < Event
    def schema_id
      6
    end

    attribute :identifier,   String, :default => "unknown".freeze
    attribute :display_name, String, :default => "unknown".freeze
  end
end
