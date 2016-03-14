namespace :schema do
  desc "Generate schemas from IDL"
  task :generate => [:environment, :clear] do
    require "tmpdir"
    tmpdir = Dir.mktmpdir
    srcdir = Pathname.new("apps/kerala/schemas")

    idls = FileList.new(srcdir + "**/*.avdl")
    tmps = idls.map do |file|
      file.pathmap("%{^#{srcdir},#{tmpdir}}d%s%{.*,*}n.avsc") do |name|
        name[/[^_]*/]
      end
    end
    schemas = idls.pathmap("%{#{srcdir},#{SCHEMAS_DIR}}d%s%n.avsc")

    idls.zip(tmps, schemas).each do |idl, tmp, schema|
      print "Generating #{schema} from #{idl} ... "
      system "java", "-jar", ENV["AVRO_TOOLS_JAR"], "idl2schemata", idl, tmp.pathmap("%d")

      mkdir_p schema.pathmap("%d"), :verbose => false
      cp tmp, schema, :verbose => false
      puts "OK"
    end
  end

  desc "Clear generated files"
  task :clear => :environment do
    rm Dir["#{SCHEMAS_DIR}/*.avsc"], :verbose => false
  end
end
