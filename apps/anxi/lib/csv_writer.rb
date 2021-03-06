module Anxi
  class CSVWriter
    SUPPORTED_SCHEMA = 2

    def initialize(output)
      @output = output
    end

    def write(line)
      output << format(line)
    end

    private

    attr_reader :output

    def format(line)
      CSV.generate_line([line["date"],
                         line["currency"],
                         line["cents"],
                         line["pay_method"],
                         line["seller"],
                         line["category"],
                         line["tags"],
                         line["description"]])
    end
  end
end
