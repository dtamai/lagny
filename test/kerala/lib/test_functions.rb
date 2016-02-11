require "helper"

module Kerala
  class TestFunctions < Minitest::Test
    class M1
      include Virtus.model
      attribute :attr_m1, Integer, :default => 1
    end

    class M2
      include Virtus.model
      attribute :m1, M1, :default => -> (_, _) { M1.new }
      attribute :attr_m2, Integer, :default => 2
    end

    class TestDeepAttributes < Minitest::Test
      def test_extract_shallow_attributes
        extend(Functions)
        m1 = M1.new

        attributes = fn(:deep_attributes)[m1]

        assert_equal({ :attr_m1 => 1 }, attributes)
      end

      def test_extract_nested_attributes
        extend(Functions)
        m2 = M2.new

        attributes = fn(:deep_attributes)[m2]

        assert_equal({ :m1 => { :attr_m1 => 1 }, :attr_m2 => 2 }, attributes)
      end
    end
  end
end
