module Murano
  class App < Roda
    opts[:root] = ::MURANO_BASE
    plugin :empty_root

    plugin :render,
      :engine => "html.erb",
      :views => File.expand_path("../views", __FILE__)

    plugin :flash
    plugin :content_for
    plugin :path

    use Rack::Session::Cookie, :secret => ::MURANO_SECRET

    route do |r|
      r.on "spendings" do
        r.run Murano::Spendings::App.freeze.app
      end

      r.on "snapshots" do
        r.run Murano::Snapshots::App.freeze.app
      end
    end
  end
end
