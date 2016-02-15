module Kerala
  class Event
    include Virtus.model

    attribute :header, Header, :default => -> (_, _) { Header.new }

    def fields
      attributes.clone.tap do |attrs|
        attrs.delete:header
      end
    end
  end
end
