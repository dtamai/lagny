module Kerala
  class SchemaRegister

    def self.fetch(schema_id)
      if filename = Config.schemas[schema_id]
        Schema.new(schema_id, File.read(File.join(SCHEMAS_DIR, filename)))
      else
        Schema.unknown
      end
    end

  end
end
