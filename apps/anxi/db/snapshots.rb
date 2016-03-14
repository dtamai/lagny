module Anxi
  module Schema
    class Snapshots
      extend DSL

      table :sn_metadata do
        column :key,   :string, :primary_key => true
        column :value, :string
      end

      table :sn_piles do
        primary_key :id
        column :pile,         :string, :null => false, :unique => true
        column :display_name, :string, :null => false
      end

      table :sn_categories do
        primary_key :id
        column :category,     :string, :null => false, :unique => true
        column :display_name, :string, :null => false
      end

      table :sn_buckets do
        primary_key :id
        column :bucket,       :string, :null => false, :unique => true
        column :display_name, :string, :null => false

        foreign_key :category, :sn_categories, :key => :category, :null => false, :type => :string
        foreign_key :pile,     :sn_piles,      :key => :pile,     :null => false, :type => :string
      end

      table :sn_snapshots do
        column :snapshot, :string,  :null => false, :unique => true
        column :year,     :integer, :null => false
        column :month,    :integer, :null => false
        column :day,      :integer, :null => false
      end
    end
  end
end
