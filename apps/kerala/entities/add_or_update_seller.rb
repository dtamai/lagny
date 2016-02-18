module Kerala
  class AddOrUpdateSeller < Event
    def schema_id
      7
    end

    attribute :identifier,   String, :default => "unknown".freeze
    attribute :display_name, String, :default => "unknown".freeze
  end
end
