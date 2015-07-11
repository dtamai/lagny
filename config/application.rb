require "rubygems"
require "bundler"

LAGNY_ENV = ENV["RACK_ENV"] || "development"
LAGNY_BASE = File.expand_path("..", File.dirname(__FILE__))

Bundler.setup(:default, LAGNY_ENV)

$LOAD_PATH.unshift(File.expand_path("../apps", File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path("../lib", File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require "dotenv"
require "roda"

Dotenv.load!(File.join(LAGNY_BASE, ".env.#{LAGNY_ENV}"))

class App < Roda
  plugin :environments

  configure :development, :test do
    require "byebug"
    require "rack/dev-mark"
    use Rack::DevMark::Middleware
  end
end

require "routes"
