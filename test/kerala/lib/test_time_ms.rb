module Kerala
  class TestTimeMs < Minitest::Test
    class Dummy
      include Virtus.model
      attribute :time_ms, TimeMs
    end

    def test_converts_time_to_epoch_in_ms
      dummy = Time.stub :now, 12.345 do
        Dummy.new(:time_ms => Time.now)
      end

      assert_equal 12_345, dummy.time_ms
    end
  end
end
