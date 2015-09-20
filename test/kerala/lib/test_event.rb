require "helper"

module Kerala
  class EventTest < Minitest::Test
    def test_fields_doesnt_include_header
      evt = Event.new

      attrs = evt.fields

      refute_includes attrs.keys, :header
    end
  end
end
