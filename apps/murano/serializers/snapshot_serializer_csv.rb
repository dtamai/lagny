module Murano
  class SnapshotSerializerCSV

    attr_reader :snapshot_entry

    def self.headers
      [
        :date,
        :bucket,
        :value
      ]
    end

    def initialize(snapshot_entry)
      @snapshot_entry = snapshot_entry
    end

    def serialize
      CSV::Row.new(self.class.headers, fields)
    end

    private

    def fields
      [
        snapshot_entry.date.to_s,
        snapshot_entry.bucket,
        sprintf("%.2f", snapshot_entry.value)
      ]
    end

  end
end
