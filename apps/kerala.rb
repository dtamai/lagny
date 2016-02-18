require "avro"
require "virtus"
require "transproc/all"
require "poseidon"
require "configatron/core"

require "lagny"

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
require "kerala/entities/add_or_update_category"
require "kerala/entities/add_or_update_pay_method"

module Kerala
  def self.logger
    Lagny::Logger
  end

  Config = Configatron::RootStore.new
  require "kerala/config/schemas"

  Config.schema_register = SchemaRegister.new
  Dir["#{SCHEMAS_DIR}/*.avsc"].each do |schema_path|
    schema_name = Pathname.new(schema_path).basename(".avsc").to_s
    id = Config.schemas[schema_name]
    unless id
      logger.error "Can't register unknown schema '#{schema_name}'"
      next
    end
    schema = Schema.new(id, File.read(schema_path))
    Config.schema_register.register schema
  end
end
