MURANO_BASE = File.expand_path("murano", File.dirname(__FILE__))
MURANO_SECRET = ENV["LAGNY_SECRET"]

require "date"

require "kerala"
require "anxi"

require "murano/lib/recent_spendings"

require "murano/apps/spendings/routes"
require "murano/apps/snapshots/routes"
require "murano/routes"
