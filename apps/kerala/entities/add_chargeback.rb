module Kerala
  class AddChargeback < Event
    attribute :date,       String,  :default => "2001-01-01".freeze
    attribute :currency,   String,  :default => "unknown".freeze
    attribute :cents,      Integer, :default => 0
    attribute :pay_method, String,  :default => "unknown".freeze
    attribute :seller,     String,  :default => "unknown".freeze

    def initialize(params = {})
      super
      cents_from_value(params["value"]) if params["value"]
    end

    def cents_from_value(value)
      value ||= 0

      self.cents = (Float(value) * 100).round
    end
  end
end
