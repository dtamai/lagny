require "murano/murano"

class App < Roda

  route do |r|
    r.on "murano" do
      r.run Murano::App.freeze.app
    end
  end

end
