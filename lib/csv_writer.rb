require "csv"

class CSVWriter

  def initialize(io, header = [])
    @csv = CSV.new(io)
    init_header(header) if blank?(io)
  end

  def append(row)
    @csv << row
  end

  private

  def init_header(header)
    header_row = CSV::Row.new(header, header, true)
    append header_row
  end

  def blank?(io)
    not io.each_line.lazy.any? { |line| line }
  end

end
