task :environment do
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
  require "config/application"
end

task :init do
  mkdir_p ["tmp", "tmp/log", "tmp/data", "tmp/run", SCHEMAS_DIR]
end

namespace :kerala do

  desc "Generate schemas from IDL"
  task :schemas do
    jar = "tmp/avro-tools-1.7.7.jar"
    Dir["tmp/*.avdl"].each do |idl|
      exec "java", "-jar", jar, "idl2schemata", idl, SCHEMAS_DIR
    end
  end
end
