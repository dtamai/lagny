require "roda"

require "murano"

class App < Roda

  plugin :render

  route do |r|
    r.on "murano" do
      r.run MuranoApp.freeze.app
    end
  end

end

run App.freeze.app
