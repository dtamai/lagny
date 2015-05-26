module Murano
class App < Roda

  opts[:root] = ::MURANO_BASE
  plugin :static, ["/js", "/css", "/fonts"]

  plugin :render,
    engine: "html.erb",
    views: File.expand_path("../views", __FILE__),
    layout: "layout"

  plugin :forme
  plugin :flash

  use Rack::Session::Cookie, secret: ::MURANO_SECRET

  def append_snapshot(snapshot)
    snapshot_writer.append SnapshotSerializerCSV.new(snapshot).serialize
    snapshot_file.flush
  end

  def snapshot_writer
    @snapshot_writer ||= CSVWriter.new(
      snapshot_file,
      SnapshotSerializerCSV.headers
    )
  end

  def snapshot_file
    @snapshot_file ||= File.open(Config[:ledger][:snapshot], "a+")
  end

  def append_spending(spending)
    spending_writer.append SpendingSerializerCSV.new(spending).serialize
    spending_file.flush
  end

  def spending_writer
    @spending_writer ||= CSVWriter.new(
      spending_file,
      SpendingSerializerCSV.headers
    )
  end

  def spending_file
    @spending_file ||= File.open(Config[:ledger][:spending], "a+")
  end

  def param_to_date(param)
    Date.new(
      param["year"].to_i,
      param["month"].to_i,
      param["day"].to_i
    )
  end

  route do |r|
    r.root do
      view "home"
    end

    r.on "snapshot" do
      branch_root = request.matched_path

      r.is do
        r.get do
          view "snapshot_entry"
        end
      end

      r.post "create" do
        entry = SnapshotEntry.new.tap do |se|
          se.date = param_to_date(r["date"])
          se.bucket = r["bucket"]
          se.value = r["value"]
        end
        append_snapshot(entry)

        r.redirect branch_root
      end
    end

    r.on "spending" do
      branch_root = r.matched_path

      r.is do
        r.get do
          view "spending"
        end
      end

      r.post "create" do
        spending = Spending.new.tap do |sp|
          sp.date = param_to_date(r["date"])
          sp.currency = r["currency"]
          sp.value = r["value"]
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
