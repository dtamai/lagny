Murano::Config.ledger do |conf|
  conf.snapshot = File.join(MURANO_BASE, ENV["DATA_DIR"], "snapshots.csv")
  conf.spending = File.join(MURANO_BASE, ENV["DATA_DIR"], "spendings.csv")
end
