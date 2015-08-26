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

    idl = FileList.new("apps/kerala/schemas/*.avdl")
    tmp = idl.map do |file|
      file.pathmap("%{.*,#{tmpdir}}X%s%{.*,*}n.avsc") { |name| name[/[^_]*/] }
    end
    schema = idl.pathmap("%{.*,#{SCHEMAS_DIR}}X%s%n.avsc")

    idl.zip(tmp, schema).each do |idl, tmp, schema|
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
  desc "Dumps spending topic to a sqlite file"
  task :"sqlite:dump" => [:environment] do
    require "anxi"
    writer = Anxi::SQLWriter.new(Anxi::DB[:spendings])
    consumer = Anxi::TopicConsumer.new(ENV["KERALA_KAFKA_CONNECTION"], "spending")
    Anxi::KeralaToSQLMigrator.new(writer, consumer).migrate
  end
end
