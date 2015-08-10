module Anxi
  class SQLWriter

    SUPPORTED_SCHEMA = 2

    def initialize(output)
      @output = output
    end

    def write(object)
      output << format(object)
    end

    private

    attr_reader :output

    def format(object)
      attributes = object.attributes
      attributes.delete :header
      attributes
    end
  end
end
