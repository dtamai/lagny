require "sequel"

module Delfshaven
  DB = Sequel.sqlite(ENV["DELFSHAVEN_DATA_FILE"])
end
