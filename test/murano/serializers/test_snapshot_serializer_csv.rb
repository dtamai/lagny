require "helper"
require "murano"

module Murano
class TestSnapshotSerializerCSV < Minitest::Test

  def test_serializes_as_csv
    serialized = SnapshotSerializerCSV.new(some_snapshot).serialize

    assert_equal snapshot_string, serialized
  end

  def snapshot_string
    %Q{2015-12-30,poupanca,5123.45\n}
  end

  def some_snapshot
    snapshot_entry = SnapshotEntry.new
    snapshot_entry.date = Date.new(2015, 12, 30)
    snapshot_entry.bucket = "poupanca"
    snapshot_entry.value = 5123.45
    snapshot_entry
  end

end
end
