Murano::Config.ledger do |conf|
  conf.snapshot = File.join(MURANO_BASE, ENV["MURANO_DATA_DIR"], "snapshots.csv")
end
