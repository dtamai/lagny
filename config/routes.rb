require "murano"

class App < Roda
  plugin :static, ["/js", "/css", "/fonts"]

  route do |r|
    r.on "murano" do
      r.run Murano::App.freeze.app
    end
  end
end
