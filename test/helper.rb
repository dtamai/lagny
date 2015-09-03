require "minitest/color"

ENV["RACK_ENV"]="test"
require_relative "../config/application"

$LOAD_PATH.unshift(File.expand_path("./../../apps/murano", __FILE__))
$LOAD_PATH.unshift(File.expand_path("./../../apps/kerala", __FILE__))

class Fake
end

def fake_schema(opts = {})
  name = opts[:name] || "Fake"
  namespace = opts[:namespace] || ""
  %Q|{
    "namespace": "#{namespace}",
    "name": "#{name}",
    "type": "record",
    "fields": [
      { "name": "field", "type": "string" }
    ]
  }|
end
