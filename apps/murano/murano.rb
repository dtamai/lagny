$LOAD_PATH.unshift(File.dirname(__FILE__))

require "date"
require "csv_writer"
require "roda"

require "models/snapshot_entry"
require "models/spending"
require "serializers/spending_serializer_csv"
require "serializers/snapshot_serializer_csv"

require "routes"

require "dotenv"
require "configatron/core"

Dotenv.load!(File.join(File.dirname(__FILE__), ".env.#{LAGNY_ENV}"))

Murano::Config = Configatron::RootStore.new
require "config/ledger"
