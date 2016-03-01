module Murano
  module Snapshots
    class App < App
      plugin :render,
             :engine => "html.erb",
             :views => File.expand_path("../views", __FILE__)

      plugin :flash
      plugin :content_for
      plugin :path

      use Rack::Session::Cookie, :secret => ::MURANO_SECRET

      path :murano, "/", :add_script_name => true
      path :piles, "/piles", :add_script_name => true

      def producer
        @producer ||= Kerala::Producer.new
      end

      def publisher
        @publisher ||= Kerala::Publisher.new(
          "murano/snapshot",
          producer,
          Kerala::Config.schema_register)
      end

      def append_event(event)
        publisher.publish(event, "snapshot")
      end

      route do |r|
        r.on "piles" do
          r.is do
            r.get do
              @piles = ::Anxi::DB[:piles].to_a
              view "piles"
            end

            r.post do
              pile = Kerala::Snapshot::AddOrUpdatePile.new(r.params)
              append_event(pile)

              r.redirect piles_path
            end
          end
        end
      end
    end
  end
end
