module Anxi
  class KeralaToSQLMigrator
    def initialize(consumer, writer)
      @consumer = consumer
      @writer = writer
    end

    def migrate
      @consumer.consume do |event|
        begin
          case event
          when Kerala::AddSpending          then process_spending event
          when Kerala::AddChargeback        then process_chargeback event
          when Kerala::AddOrUpdateCategory  then process_category event
          when Kerala::AddOrUpdatePayMethod then process_pay_method event
          when Kerala::AddOrUpdateSeller    then process_seller event
          else next
          end
        rescue StandardError => e
          $stderr << ["[#{self.class.name}]", "Error processing",
                      "class=#{event.class}", "attributes=#{event.to_h}", e
                     ].join("\t")
        end
      end
    end

    def process_spending(event)
      @writer.insert(event, :table => :spendings)
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

    def process_category(event)
      @writer.update_or_insert(
        event, :table => :categories,
               :where => -> { { :identifier => event.identifier } })
    end

    def process_pay_method(event)
      @writer.update_or_insert(
        event, :table => :pay_methods,
               :where => -> { { :identifier => event.identifier } })
    end

    def process_seller(event)
      @writer.update_or_insert(
        event, :table => :sellers,
               :where => -> { { :identifier => event.identifier } })
    end
  end
end
