module Murano
  class SnapshotSerializerCSV

    attr_reader :snapshot_entry

    def initialize(snapshot_entry)
      @snapshot_entry = snapshot_entry
    end

    def serialize
      CSV::Row.new(headers, fields)
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
        snapshot_entry.date.to_s,
        snapshot_entry.bucket,
        sprintf("%.2f", snapshot_entry.value)
      ]
    end

  end
end
