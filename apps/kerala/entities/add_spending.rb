module Kerala
  class AddSpending < Event
    def schema_id
      3
    end

    attribute :date,        String,        default: "2001-01-01".freeze
    attribute :currency,    String,        default: "unknown".freeze
    attribute :cents,       Integer,       default: 0
    attribute :pay_method,  String,        default: "unknown".freeze
    attribute :seller,      String,        default: "unknown".freeze
    attribute :category,    String,        default: "unknown".freeze
    attribute :tags,        Array[String], default: []
    attribute :description, String,        default: "unknown".freeze

    def initialize(params = {})
      super
      cents_from_value(params["value"]) if params["value"]
    end

    def cents_from_value(value)
      self.cents = (Float(value) * 100).round
    end

    def value_from_cents
      cents/100.0
    end
  end

end
