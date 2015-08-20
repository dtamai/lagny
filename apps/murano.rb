MURANO_BASE = File.expand_path("murano", File.dirname(__FILE__))
MURANO_SECRET = ENV["LAGNY_SECRET"]

Murano::Config = Configatron::RootStore.new

require "date"

require "murano/routes"

require "kerala"
