module Kerala
  class Event
    include Virtus.model

    attribute :header, Header, :default => lambda { |_, _| Header.new }
  end
end
