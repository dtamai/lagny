require "poseidon"
require "avro"
require "csv"
require "sequel"

require "kerala"

require "anxi/lib/topic_consumer"
require "anxi/lib/csv_writer"
require "anxi/lib/csv_to_kerala_migrator"

Anxi::DB = Sequel.connect("sqlite://tmp/anxi.db")

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
