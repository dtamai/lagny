module Kerala
  class AddOrUpdateCategory < Event
    def schema_id
      5
    end

    attribute :identification, String, :default => "unknown".freeze
    attribute :display_name,   String, :default => "unknown".freeze
  end
end
