module Kerala
  class SchemaRegister
    def fetch(schema_id)
      cache[schema_id]
    end

    def fetch_for(object)
      class_cache[object.class]
    end

    def register(schema)
      cache[schema.id] = schema
      class_cache[schema.event_class] = schema
    end

    private

    def cache
      @cache ||= Hash.new { Schema.unknown }
    end

    def class_cache
      @class_cache ||= Hash.new { Schema.unknown }
    end
  end
end
