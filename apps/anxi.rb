require "poseidon"
require "avro"
require "csv"
require "sequel"

require "kerala"

require "anxi/lib/metadata/sql"
require "anxi/lib/topic_consumer"
require "anxi/lib/csv_writer"
require "anxi/lib/sql_writer"
require "anxi/lib/csv_to_kerala_migrator"
require "anxi/lib/kerala_to_sqlite_migrator"
require "anxi/lib/kerala_to_sqlite_finalizer"

Anxi::DB = Sequel.connect("sqlite://tmp/anxi.db")
