module Kerala
  class SchemaRegister
    def fetch(schema_id)
      cache[schema_id]
    end

    def register(schema)
      cache[schema.id] = schema
    end

    private

    def cache
      @cache ||= Hash.new { Schema.unknown }
    end
  end
end
