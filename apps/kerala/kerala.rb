$LOAD_PATH.unshift(File.dirname(__FILE__))

require "avro"

require "lib/schema"
require "lib/schema_register"

require "configatron/core"

Kerala::Config = Configatron::RootStore.new
require "config/schemas"
