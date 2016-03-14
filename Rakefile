Dir["**/rakelib"].each { |rakelib| Rake.add_rakelib rakelib }

task :environment do
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
  require "config/application"
end
