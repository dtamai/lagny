require "helper"
require "delfshaven"

class TestDelfshaven < Minitest::Test
  def setup
    @conn ||= Sequel.connect("sqlite:/")
    setup_db
  end

  attr_reader :conn

  def test_writes_spending
    spending = Kerala::AddSpending.new(:seller => "Test")
    dh = Delfshaven.new conn

    dh.handle_spending spending

    assert_equal 1, table.where(:seller => "Test").count
  end

  def test_match_and_destroy_spending_with_chargeback
    dh = Delfshaven.new conn
    spending_1 = Kerala::AddSpending.new(:seller => "Test1")
    spending_2 = Kerala::AddSpending.new(:seller => "Test2")
    chargeback = chargeback_for spending_2
    dh.handle_spending spending_1
    dh.handle_spending spending_2

    dh.handle_chargeback chargeback

    assert_equal 1, table.where(:seller => "Test1").count,
                 "Spending for seller Test1 must be kept"
    assert_equal 0, table.where(:seller => "Test2").count,
                 "Spending for seller Test2 must be destroyed"
  end

  def chargeback_for(spending)
    Kerala::AddChargeback.new(
          :date => spending.date,
      :currency => spending.currency,
         :cents => spending.cents,
        :seller => spending.seller
    )
  end

  def table
    conn[:spendings]
  end

  def setup_db
    conn.create_table!(:spendings) do
      primary_key :id
      String :date, :fixed => true, :size => 10, :null => false
      String :currency, :fixed => true, :size => 3, :null => false
      Integer :cents, :null => false
      String :pay_method, :null => false
      String :seller, :null => false
      String :category, :null => false
      String :tags
      String :description, :null => false
    end
  end
end
