require "helper"
require "murano"

module Murano
class TestSnapshotSerializerCSV < Minitest::Test

  def test_serializes_as_csv
    serialized = SnapshotSerializerCSV.new(some_snapshot).serialize
    row = CSV.parse(
      snapshot_string,
      headers: true, header_converters: :symbol
    ).first

    assert_equal row, serialized
  end

  def snapshot_string
    <<-EOL.gsub(/^\s{6}/, "")
      date,bucket,value
      2015-12-30,poupanca,5123.45
    EOL
  end

  def some_snapshot
    SnapshotEntry.new.tap do |se|
      se.date = Date.new(2015, 12, 30)
      se.bucket = "poupanca"
      se.value = 5123.45
    end
  end

end
end
