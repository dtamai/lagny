require "helper"
require "csv_writer"

class TestCSVWriter < Minitest::Test

  def test_write_header_when_file_is_empty
    file = String.new
    header = [:col1, :col2]

    writer = CSVWriter.new(file, header)

    assert_equal "col1,col2\n", file
  end

  def test_do_not_write_header_when_file_has_content
    file = "col1,col2\n"
    header = [:col1, :col2]

    writer = CSVWriter.new(file, header)

    assert_equal "col1,col2\n", file
  end

  def test_append_row
    file = String.new
    header = [:col]
    writer = CSVWriter.new(file, header)
    row = CSV::Row.new(header, [1])

    writer.append row

    assert_equal "col\n1\n", file
  end

end
