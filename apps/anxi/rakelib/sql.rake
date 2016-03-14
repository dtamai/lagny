namespace :db do
  task :setup => [:environment] do
    require "anxi"
    require "anxi/lib/schema/dsl"
    require "anxi/db/spendings"
    require "anxi/db/snapshots"
  end

  desc "Dumps all topics to a sqlite file"
  task :"sqlite:dump" =>
        [:setup,
         :"sqlite:create",
         :"sqlite:dump:spendings", :"sqlite:dump:snapshots"] do
  end

  task :"sqlite:dump:spendings" => [:setup, :"sqlite:create"] do
    metadata = Anxi::Metadata::Sql.new(Anxi::DB[:__spendings_metadata])
    writer = Anxi::SQLWriter.new(Anxi::DB[:spendings])
    offset = Integer(metadata.get(:latest_offset) || 0)
    consumer = Anxi::TopicConsumer.new(
      ENV["KERALA_KAFKA_CONNECTION"], "spending", offset)

    Anxi::DB.transaction do
      Anxi::KeralaToSQLMigrator.new(writer, consumer).migrate
      Anxi::KeralaToSQLFinalizer.new(metadata, consumer).finalize
    end
  end

  task :"sqlite:dump:snapshots" => [:setup, :"sqlite:create"] do
    metadata = Anxi::Metadata::Sql.new(Anxi::DB[:sn_metadata])
    offset = Integer(metadata.get(:latest_offset) || 0)
    consumer = Anxi::TopicConsumer.new(
      ENV["KERALA_KAFKA_CONNECTION"], "snapshot", offset)

    Anxi::DB.transaction do
      Anxi::Snapshot::KeralaToSQLMigrator.new(consumer).migrate
      Anxi::KeralaToSQLFinalizer.new(metadata, consumer).finalize
    end
  end

  desc "Recreates tables"
  task "sqlite:reset" => ["sqlite:drop", "sqlite:create"]

  desc "Create tables"
  task "sqlite:create" => [:setup] do
    Anxi::Schema::Spendings.create
    Anxi::Schema::Snapshots.create
  end

  desc "Drop tables"
  task "sqlite:drop" => [:setup] do
    Anxi::Schema::Spendings.drop
    Anxi::Schema::Snapshots.drop
  end
end
