module Murano
  module Snapshots
    class App < Roda
      plugin :render,
             :engine => "html.erb",
             :views => File.expand_path("../views", __FILE__)

      plugin :flash
      plugin :content_for
      plugin :path

      use Rack::Session::Cookie, :secret => ::MURANO_SECRET

      path :murano, "/", :add_script_name => true
      path :piles, "/piles", :add_script_name => true
      path :categories, "/categories", :add_script_name => true
      path :buckets, "/buckets", :add_script_name => true

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
              @piles = ::Anxi::DB[:sn_piles].to_a
              view "piles"
            end

            r.post do
              pile = Kerala::Snapshot::AddOrUpdatePile.new(r.params)
              append_event(pile)

              r.redirect piles_path
            end
          end
        end

        r.on "categories" do
          r.is do
            r.get do
              @categories = ::Anxi::DB[:sn_categories].to_a
              view "categories"
            end

            r.post do
              category = Kerala::Snapshot::AddOrUpdateCategory.new(r.params)
              append_event(category)

              r.redirect categories_path
            end
          end
        end

        r.on "buckets" do
          r.is do
            r.get do
              @piles = ::Anxi::DB[:sn_piles].to_a
              @categories = ::Anxi::DB[:sn_categories].to_a
              @buckets = ::Anxi::DB[:sn_buckets].to_a
              view "buckets"
            end

            r.post do
              bucket = Kerala::Snapshot::AddOrUpdateBucket.new(r.params)
              append_event(bucket)

              r.redirect buckets_path
            end
          end
        end
      end
    end
  end
end
