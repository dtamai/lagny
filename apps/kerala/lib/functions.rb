module Kerala
  module Functions
    extend Transproc::Registry

    import Transproc::Conditional
    import Transproc::Recursion
    import Transproc::HashTransformations

    def fn(*args)
      Functions[*args]
    end

    def self.deep_attributes(value)
      extractor = _extractor(:attributes)

      result = extractor[value]
      if result.is_a? ::Hash
        result.keys.each do |key| 
          result[key] = extractor[result.delete(key)]
        end
      end

      result
    end

    private

    def self._extractor(attr)
      Functions[:guard, -> v { v.respond_to?(attr) }, -> v { v.send(attr) }]
    end

  end
end

