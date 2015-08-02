KERALA_BASE = File.expand_path("kerala", File.dirname(__FILE__))

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

require "kerala/entities/add_spending"

module Kerala
  Config = Configatron::RootStore.new
  require "kerala/config/schemas"

  Config.schema_register = SchemaRegister.new
  Dir["#{SCHEMAS_DIR}/*.avsc"].each do |schema_path|
    schema_name = Pathname.new(schema_path).basename.to_s
    id = Config.schemas[schema_name]
    next unless id
    schema = Schema.new(id, File.read(schema_path))
    Config.schema_register.register schema
  end
end
