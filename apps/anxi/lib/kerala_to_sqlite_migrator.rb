module Anxi
  class KeralaToSQLMigrator
    SUPPORTED_SCHEMA = 2

    def initialize(writer, consumer)
      @writer = writer
      @consumer = consumer
    end

    def migrate
      @consumer.consume do |event|
        case event
        when Kerala::AddSpending then @writer.write event
        when Kerala::AddChargeback then process_chargeback event
        else next
        end
      end
    end

    def process_chargeback(event)
      candidates = Anxi::DB[:spendings].where(
        :date       => event.date,
        :currency   => event.currency,
        :cents      => event.cents,
        :pay_method => event.pay_method,
        :seller     => event.seller).order(:date).limit(1)

      Kerala.logger.warn(
        "Unmatched chargeback: #{event.attributes}") if candidates.empty?

      candidates.delete
    end

    def process_spending(event)
      @writer.write event
    end
  end
end
