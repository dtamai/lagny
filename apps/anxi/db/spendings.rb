module Anxi
  module Schema
    class Spendings
      extend DSL

      table :__spendings_metadata do
        column :key,   :string, :primary_key => true
        column :value, :string
      end

      table :spendings do
        primary_key :id
        column :date,        :string,  :null => false
        column :currency,    :string,  :null => false
        column :cents,       :integer, :null => false
        column :pay_method,  :string,  :null => false
        column :seller,      :string,  :null => false
        column :category,    :string,  :null => false
        column :description, :string,  :null => false
        column :tags,        :string
      end

      table :categories do
        primary_key :id
        column :identifier,   :string, :null => false, :unique => true
        column :display_name, :string, :null => false
      end

      table :pay_methods do
        primary_key :id
        column :identifier,   :string, :null => false, :unique => true
        column :display_name, :string, :null => false
      end

      table :sellers do
        primary_key :id
        column :identifier,   :string, :null => false, :unique => true
        column :display_name, :string, :null => false
      end
    end
  end
end
