require "minitest/color"

ENV["RACK_ENV"]="test"
require_relative "../config/application"

$LOAD_PATH.unshift(File.expand_path("./../../apps/murano", __FILE__))
