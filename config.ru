require "roda"

$LOAD_PATH.unshift(File.expand_path("../apps", __FILE__))
$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))

require "murano/murano"

class App < Roda

  plugin :render

  route do |r|
    r.on "murano" do
      r.run MuranoApp.freeze.app
    end
  end

end

run App.freeze.app
