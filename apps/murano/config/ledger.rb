Murano::Config.ledger do |conf|
  conf.snapshots = File.join(ENV["DATA_DIR"], "snapshots.csv")
  conf.spendings = File.join(ENV["DATA_DIR"], "spendings.csv")
end
