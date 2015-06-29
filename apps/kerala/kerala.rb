$LOAD_PATH.unshift(File.dirname(__FILE__))

SCHEMAS_DIR = File.expand_path("schemas", File.dirname(__FILE__))

require "avro"
require "virtus"
require "transproc"
require "poseidon"

require "lib/schema"
require "lib/schema_register"
require "lib/serializer"
require "lib/producer"

require "entities/spending"

require "configatron/core"

Kerala::Config = Configatron::RootStore.new
require "config/schemas"
