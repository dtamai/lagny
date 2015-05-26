require "rubygems"
require "bundler"
Bundler.setup(:default, ENV["RACK_ENV"])

LAGNY_ENV = ENV["RACK_ENV"] || "development"
LAGNY_BASE = File.expand_path("../..", __FILE__)

$LOAD_PATH.unshift(File.expand_path("../../apps", __FILE__))
$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))
$LOAD_PATH.unshift(File.expand_path("../", __FILE__))

require "dotenv"
require "roda"

Dotenv.load!(File.join(LAGNY_BASE, ".env.#{LAGNY_ENV}"))

class App < Roda
  plugin :environments

  configure :development, :test do
    require "byebug"
  end
end

require "routes"
