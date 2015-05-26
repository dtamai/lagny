$LOAD_PATH.unshift(File.dirname(__FILE__))

MURANO_BASE = File.expand_path(File.dirname(__FILE__))
MURANO_SECRET = ENV["LAGNY_SECRET"]

require "date"
require "csv_writer"
require "roda"

require "models/snapshot_entry"
require "models/spending"
require "serializers/spending_serializer_csv"
require "serializers/snapshot_serializer_csv"

require "routes"

require "configatron/core"

Dotenv.load!(File.join(MURANO_BASE, ".env.#{LAGNY_ENV}"))

Murano::Config = Configatron::RootStore.new
require "config/ledger"
