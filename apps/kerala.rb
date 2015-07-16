KERALA_BASE = File.expand_path("kerala", File.dirname(__FILE__))
SCHEMAS_DIR = File.expand_path("schemas", KERALA_BASE)

require "avro"
require "virtus"
require "transproc/all"
require "poseidon"
require "configatron/core"

require "kerala/lib/functions"
require "kerala/lib/schema"
require "kerala/lib/schema_register"
require "kerala/lib/serializer"
require "kerala/lib/producer"

require "kerala/entities/spending"

Kerala::Config = Configatron::RootStore.new
require "kerala/config/schemas" unless LAGNY_ENV == "test"
