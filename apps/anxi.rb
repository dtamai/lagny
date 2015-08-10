require "poseidon"
require "avro"
require "csv"
require "sequel"

require "kerala"

require "anxi/lib/topic_consumer"
require "anxi/lib/csv_writer"
require "anxi/lib/csv_to_kerala_migrator"

Anxi::DB = Sequel.connect("sqlite://tmp/anxi.db")

