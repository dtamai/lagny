module Murano
  class SnapshotSerializerCSV

    attr_reader :snapshot_entry

    def initialize(snapshot_entry)
      @snapshot_entry = snapshot_entry
    end

    def serialize
      CSV::Row.new(headers, fields).to_csv
    end

    private

    def headers
      [
        :date,
        :bucket,
        :value
      ]
    end

    def fields
      [
        snapshot_entry.date,
        snapshot_entry.bucket,
        snapshot_entry.value
      ]
    end

  end
end
