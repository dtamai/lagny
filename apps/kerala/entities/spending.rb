module Kerala
  class Spending
    include Virtus.model

    def schema_id
      1
    end

    attribute :date,        String,        default: "2001-01-01".freeze
    attribute :currency,    String,        default: "unknown".freeze
    attribute :value,       Float,         default: 0.0
    attribute :pay_method,  String,        default: "unknown".freeze
    attribute :seller,      String,        default: "unknown".freeze
    attribute :category,    String,        default: "unknown".freeze
    attribute :tags,        Array[String], default: []
    attribute :description, String,        default: "unknown".freeze
  end
end
