module Kerala
  class SchemaRegister

    def self.fetch(schema_id)
      if filename = Config.schemas[schema_id]
        Schema.new(File.read(filename))
      else
        Schema.unknown
      end
    end

  end
end
