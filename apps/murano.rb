MURANO_BASE = File.expand_path("murano", File.dirname(__FILE__))
MURANO_SECRET = ENV["LAGNY_SECRET"]

require "date"
require "csv_writer"
require "configatron/core"

require "murano/models/snapshot_entry"
require "murano/models/spending"
require "murano/serializers/spending_serializer_csv"
require "murano/serializers/snapshot_serializer_csv"

require "murano/routes"

Dotenv.load!(File.join(MURANO_BASE, ".env.#{LAGNY_ENV}"))

Murano::Config = Configatron::RootStore.new
require "murano/config/ledger"

require "kerala"
