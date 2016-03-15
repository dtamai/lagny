namespace :db do
  task :setup => [:environment] do
    require "anxi"
    require "anxi/lib/schema/dsl"
    require "anxi/db/spendings"
    require "anxi/db/snapshots"
  end

  desc "Dumps all topics to a sqlite file"
  task :dump =>
        [:setup,
         "sqlite:dump:spendings", "sqlite:dump:snapshots"] do
  end

  task "sqlite:dump:spendings" => [:setup] do
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

  task "sqlite:dump:snapshots" => [:setup] do
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
  task :reset => [:drop, :create]

  desc "Create tables"
  task :create => [:setup] do
    Anxi::Schema::Spendings.create
    Anxi::Schema::Snapshots.create
  end

  desc "Drop tables"
  task :drop => [:setup] do
    Anxi::Schema::Spendings.drop
    Anxi::Schema::Snapshots.drop
  end
end
