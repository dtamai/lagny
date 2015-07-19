module Kerala
  class Header
    include Virtus.model

    attribute :publishing_time, TimeMs, default: 0
    attribute :publisher,       String, default: ""
  end
end
