Murano::Config.ledger do |conf|
  conf.snapshot = File.join(MURANO_BASE, ENV["DATA_DIR"], "snapshots.csv")
end
