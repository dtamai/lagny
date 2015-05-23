require "rubygems"
require "bundler"
Bundler.setup(:default, ENV["RACK_ENV"])

$LOAD_PATH.unshift(File.expand_path("../../apps", __FILE__))
$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))
$LOAD_PATH.unshift(File.expand_path("../", __FILE__))

require "roda"

class App < Roda
  plugin :environments

  configure :development, :test do
    require "byebug"
  end
end

require "routes"
