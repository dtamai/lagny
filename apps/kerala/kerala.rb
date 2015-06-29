$LOAD_PATH.unshift(File.dirname(__FILE__))

SCHEMAS_DIR = File.expand_path("schemas", File.dirname(__FILE__))

require "avro"
require "virtus"
require "transproc"

require "lib/schema"
require "lib/schema_register"
require "lib/serializer"

require "configatron/core"

Kerala::Config = Configatron::RootStore.new
require "config/schemas"
