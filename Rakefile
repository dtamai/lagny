Dir["**/rakelib"].each { |rakelib| Rake.add_rakelib rakelib }

task :environment do
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
  require "config/application"
end

task :init => :environment do
  mkdir_p ["tmp", "tmp/log", "tmp/data", "tmp/run", SCHEMAS_DIR]
end

namespace :anxi do
  task :setup => [:environment] do
    require "anxi"
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
    metadata = Anxi::Metadata::Sql.new(Anxi::DB[:__snapshots_metadata])
    offset = Integer(metadata.get(:latest_offset) || 0)
    consumer = Anxi::TopicConsumer.new(
      ENV["KERALA_KAFKA_CONNECTION"], "snapshot", offset)

    Anxi::DB.transaction do
      Anxi::Snapshot::KeralaToSQLMigrator.new(consumer).migrate
      Anxi::KeralaToSQLFinalizer.new(metadata, consumer).finalize
    end
  end

  desc "Recreates spendings tables"
  task :"sqlite:reset" => [:"sqlite:drop", :"sqlite:create"]

  task :"sqlite:create" => [:"sqlite:create:spendings",
                            :"sqlite:create:snapshots"]

  task :"sqlite:create:spendings" => [:setup] do
    Anxi::DB.create_table?(:spendings) do
      primary_key :id
      String :date, :fixed => true, :size => 10, :null => false
      String :currency, :fixed => true, :size => 3, :null => false
      Integer :cents, :null => false
      String :pay_method, :null => false
      String :seller, :null => false
      String :category, :null => false
      String :tags
      String :description, :null => false
    end

    Anxi::DB.create_table?(:__spendings_metadata) do
      String :key, :primary_key => true
      String :value
    end

    Anxi::DB.create_table?(:categories) do
      primary_key :id
      String :identifier, :fixed => true, :size => 50,
                          :null => false, :unique => true
      String :display_name, :fixed => true, :size => 50, :null => false
    end

    Anxi::DB.create_table?(:pay_methods) do
      primary_key :id
      String :identifier, :fixed => true, :size => 50,
                          :null => false, :unique => true
      String :display_name, :fixed => true, :size => 50, :null => false
    end

    Anxi::DB.create_table?(:sellers) do
      primary_key :id
      String :identifier, :fixed => true, :size => 50,
                          :null => false, :unique => true
      String :display_name, :fixed => true, :size => 50, :null => false
    end
  end

  task :"sqlite:create:snapshots" => [:setup] do
    Anxi::DB.create_table?(:__snapshots_metadata) do
      String :key, :primary_key => true
      String :value
    end

    Anxi::DB.create_table?(:sn_piles) do
      primary_key :id
      String :pile, :fixed => true, :size => 50,
                    :null => false, :unique => true
      String :display_name, :fixed => true, :size => 50, :null => false
    end

    Anxi::DB.create_table?(:sn_categories) do
      primary_key :id
      String :category, :fixed => true, :size => 50,
                        :null => false, :unique => true
      String :display_name, :fixed => true, :size => 50, :null => false
    end

    Anxi::DB.create_table?(:sn_buckets) do
      primary_key :id

      String :bucket, :null   => false,
                      :fixed  => true,
                      :size   => 50,
                      :unique => true

      String :display_name, :null  => false,
                            :fixed => true,
                            :size  => 50

      foreign_key :category, :sn_categories, :key => :category,
                                             :null => false,
                                             :type => String,
                                             :fixed => true,
                                             :size => 50

      foreign_key :pile, :sn_piles, :key   => :pile,
                                    :null  => false,
                                    :type  => String,
                                    :fixed => true,
                                    :size  => 50
    end

    Anxi::DB.create_table?(:sn_snapshots) do
      String :snapshot, :null   => false,
                        :fixed  => true,
                        :size   => 50,
                        :unique => true

      Integer :year,  :null => false
      Integer :month, :null => false
      Integer :day,   :null => false
    end
  end

  task :"sqlite:drop" => [:"sqlite:drop:spendings",
                          :"sqlite:drop:snapshots"]

  task :"sqlite:drop:spendings" => [:setup] do
    Anxi::DB.drop_table?(:spendings)
    Anxi::DB.drop_table?(:__spendings_metadata)
    Anxi::DB.drop_table?(:categories)
    Anxi::DB.drop_table?(:pay_methods)
    Anxi::DB.drop_table?(:sellers)
  end

  task :"sqlite:drop:snapshots" => [:setup] do
    Anxi::DB.drop_table?(:__snapshots_metadata)
    Anxi::DB.drop_table?(:sn_buckets)
    Anxi::DB.drop_table?(:sn_piles)
    Anxi::DB.drop_table?(:sn_categories)
    Anxi::DB.drop_table?(:sn_snapshots)
  end

  desc "Dumps spending topic to a csv file"
  task :"csv:dump" => [:setup] do
    begin
      file = File.open("tmp/anxi.csv", "w+")
      consumer = Anxi::TopicConsumer.new(
        ENV["KERALA_KAFKA_CONNECTION"], "spending")
      writer = Anxi::CSVWriter.new(file)
      consumer.consume do |msg|
        writer.write msg
      end
    ensure
      file.close
    end
  end
end
