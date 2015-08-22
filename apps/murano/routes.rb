module Murano
class App < Roda

  opts[:root] = ::MURANO_BASE
  plugin :empty_root

  plugin :render,
    engine: "html.erb",
    views: File.expand_path("../views", __FILE__)

  plugin :flash

  use Rack::Session::Cookie, secret: ::MURANO_SECRET

  def producer
    @producer ||= Kerala::Producer.new("localhost:9092")
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

  route do |r|
    r.root do
      view "home"
    end

    r.on "spending" do
      branch_root = r.matched_path

      r.is do
        r.get do
          view "spending"
        end
      end

      r.post "create" do
        spending = Kerala::AddSpending.new.tap do |sp|
          sp.date = param_to_date(r["date"])
          sp.currency = r["currency"]
          sp.cents_from_value(r["value"])
          sp.pay_method = r["pay_method"]
          sp.seller = r["seller"]
          sp.category = r["category"]
          sp.tags = r["tags"]
          sp.description = r["description"]
        end
        append_spending(spending)

        r.redirect branch_root
      end
    end
  end
end
end
