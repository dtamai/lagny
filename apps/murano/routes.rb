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

    def producer
      @producer ||= Kerala::Producer.new
    end

    def publisher
      @publisher ||= Kerala::Publisher.new(
        "murano",
        producer,
        Kerala::Config.schema_register)
    end

    def append_spending(spending)
      publisher.publish(spending, "spending")
    end

    def param_to_date(param)
      Date.parse(param)
    end

    def recent_spendings
      @recent_spendings ||= RecentSpendings.new.fetch
    end

    path :murano, "/", :add_script_name => true
    path :spendings, "/spendings", :add_script_name => true
    path :pay_methods, "/pay-methods", :add_script_name => true
    path :sellers, "/sellers", :add_script_name => true
    path :categories, "/categories", :add_script_name => true

    route do |r|
      @nav_items = {
        :spendings     => "Spendings",
        :"pay-methods" => "Pay methods",
        :sellers       => "Sellers",
        :categories    => "Categories",
      }

      r.root do
        view "home"
      end

      r.on "spendings" do
        r.is do
          r.get do
            @categories = ::Anxi::DB[:categories].order(:display_name).to_a
            @pay_methods = ::Anxi::DB[:pay_methods].order(:display_name).to_a
            @sellers = ::Anxi::DB[:sellers].order(:display_name).to_a
            @last_entries = recent_spendings
            view "spendings"
          end

          r.post do
            r.params["date"] = param_to_date(r.params["date"])
            spending = Kerala::AddSpending.new(r.params)
            append_spending(spending)

            r.redirect spendings_path
          end
        end
      end

      r.on "chargebacks" do
        r.is do
          r.post do
            r.params["date"] = param_to_date(r.params["date"])
            chargeback = Kerala::AddChargeback.new(r.params)
            append_spending(chargeback)

            r.redirect spendings_path
          end
        end
      end

      r.on "categories" do
        r.is do
          r.get do
            @categories = ::Anxi::DB[:categories].to_a
            view "categories"
          end

          r.post do
            category = Kerala::AddOrUpdateCategory.new(r.params)
            append_spending(category)

            r.redirect categories_path
          end
        end
      end

      r.on "pay-methods" do
        r.is do
          r.get do
            @pay_methods = ::Anxi::DB[:pay_methods].to_a
            view "pay_methods"
          end

          r.post do
            pay_method = Kerala::AddOrUpdatePayMethod.new(r.params)
            append_spending(pay_method)

            r.redirect pay_methods_path
          end
        end
      end

      r.on "sellers" do
        r.is do
          r.get do
            @sellers = ::Anxi::DB[:sellers].to_a
            view "sellers"
          end

          r.post do
            seller = Kerala::AddOrUpdateSeller.new(r.params)
            append_spending(seller)

            r.redirect sellers_path
          end
        end
      end
    end
  end
end
