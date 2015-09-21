require "sequel"
require "kerala"

class Delfshaven
  def initialize(conn = Sequel.connect(ENV["DELFSHAVEN_DATA_FILE"]))
    setup_db conn
    @table = conn[:spendings]
  end

  def handle_spending(spending)
    table.insert spending.fields
  end

  def handle_chargeback(chargeback)
    table.where(chargeback.fields).delete
  end

  private

  attr_reader :table

  def setup_db(conn)
    conn.create_table!(:spendings) do
      primary_key :id
      String  :date,      :fixed => true, :size => 10, :null => false
      String  :currency,  :fixed => true, :size => 3,  :null => false
      Integer :cents,                                  :null => false
      String  :pay_method,                             :null => false
      String  :seller,                                 :null => false
      String  :category,                               :null => false
      String  :tags
      String  :description,                            :null => false
    end
  end

  class Main
    def self.run
      dh = Delfshaven.new

      consumer = Kerala::SimpleConsumer.new("spending")
      consumer.consume do |event|
        case event
        when Kerala::AddSpending then dh.handle_spending event
        when Kerala::AddChargeback then dh.handle_chargeback event
        end
      end
    end
  end
end
