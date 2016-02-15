module Murano
  class App < Roda
    opts[:root] = ::MURANO_BASE
    plugin :empty_root

    plugin :render,
      :engine => "html.erb",
      :views => File.expand_path("../views", __FILE__)

    plugin :flash

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

    route do |r|
      r.root do
        view "home"
      end

      r.on "spendings" do
        branch_root = r.matched_path

        r.is do
          r.get do
            @last_entries = recent_spendings
            view "spendings"
          end

          r.post do
            r.params["date"] = param_to_date(r.params["date"])
            spending = Kerala::AddSpending.new(r.params)
            append_spending(spending)

            r.redirect branch_root
          end
        end
      end

      r.on "chargebacks" do
        r.is do
          r.post do
            r.params["date"] = param_to_date(r.params["date"])
            chargeback = Kerala::AddChargeback.new(r.params)
            append_spending(chargeback)

            r.redirect "#{r.script_name}/spendings"
          end
        end
      end
    end
  end
end
