require "sequel"

class Delfshaven
  def initialize(output = Sequel.connect(ENV["DELFSHAVEN_DATA_FILE"]))
    @table = output[:spendings]
  end

  def handle_spending(spending)
    table.insert spending.fields
  end

  def handle_chargeback(chargeback)
    table.where(chargeback.fields).delete
  end

  private

  attr_reader :table
end
