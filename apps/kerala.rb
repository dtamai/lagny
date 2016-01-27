require "avro"
require "virtus"
require "transproc/all"
require "poseidon"
require "configatron/core"

require "kerala/lib/functions"
require "kerala/lib/schema"
require "kerala/lib/schema_register"
require "kerala/lib/time_ms"
require "kerala/lib/publisher"
require "kerala/lib/serializer"
require "kerala/lib/producer"
require "kerala/lib/header"
require "kerala/lib/event"
require "kerala/lib/simple_consumer"

require "kerala/entities/add_spending"
require "kerala/entities/add_chargeback"

module Kerala
  Config = Configatron::RootStore.new
  require "kerala/config/schemas"

  begin
    logger_type = case LAGNY_ENV
                  when "test" then { :type => :file, :path => "/dev/null" }
                  else { :type => :stdout }
                  end

    Logger = LogStashLogger.new logger_type
  end

  Config.schema_register = SchemaRegister.new
  Dir["#{SCHEMAS_DIR}/*.avsc"].each do |schema_path|
    schema_name = Pathname.new(schema_path).basename(".avsc").to_s
    id = Config.schemas[schema_name]
    unless id
      Logger.error "Can't register unknown schema '#{schema_name}'"
      next
    end
    schema = Schema.new(id, File.read(schema_path))
    Config.schema_register.register schema
  end
end
