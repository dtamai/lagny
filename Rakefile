task :environment do
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
  require "config/application"
end

task :init => :environment do
  mkdir_p ["tmp", "tmp/log", "tmp/data", "tmp/run", SCHEMAS_DIR]
end

namespace :kerala do
  desc "Generate schemas from IDL"
  task :schemas => [:environment, :clear] do
    require "tmpdir"
    tmpdir = Dir.mktmpdir

    idls = FileList.new("apps/kerala/schemas/*.avdl")
    tmps = idl.map do |file|
      file.pathmap("%{.*,#{tmpdir}}X%s%{.*,*}n.avsc") { |name| name[/[^_]*/] }
    end
    schemas = idl.pathmap("%{.*,#{SCHEMAS_DIR}}X%s%n.avsc")

    idls.zip(tmps, schemas).each do |idl, tmp, schema|
      puts "Generating #{schema} from #{idl}"
      system "java", "-jar", ENV["AVRO_TOOLS_JAR"], "idl2schemata", idl, tmpdir
      cp tmp, schema, :verbose => false
    end
  end

  desc "Clear generated files"
  task :clear => :environment do
    rm Dir["#{SCHEMAS_DIR}/*.avsc"], :verbose => false
  end
end

namespace :anxi do
  task :setup => [:environment] do
    require "anxi"
  end

  desc "Dumps spending topic to a sqlite file"
  task :"sqlite:dump" => [:setup, :"sqlite:reset"] do
    require "anxi"
    writer = Anxi::SQLWriter.new(Anxi::DB[:spendings])
    consumer = Anxi::TopicConsumer.new(
      ENV["KERALA_KAFKA_CONNECTION"], "spending")
    Anxi::KeralaToSQLMigrator.new(writer, consumer).migrate
    Anxi::DB[:__spendings_metadata].insert(["updated_at", Time.now])
  end

  desc "Recreates spendings table"
  task :"sqlite:reset" => [:setup] do
    Anxi::DB.create_table!(:spendings) do
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

    Anxi::DB.create_table!(:__spendings_metadata) do
      String :key, :primary_key => true
      String :value
    end
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
