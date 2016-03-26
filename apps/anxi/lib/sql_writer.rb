module Anxi
  class SQLWriter
    def initialize(conn)
      @conn = conn
    end

    def insert(event, table:)
      conn[table].insert(format(event))
    end

    def update(event, table:, where:)
      conn[table].where(&where).update(format(event))
    end

    def update_or_insert(event, table:, where:)
      conn.transaction do
        insert(event, :table => table) if update(event, :table => table, :where => where) == 0
      end
    end

    private

    attr_reader :conn

    def format(event)
      attributes = event.attributes
      attributes.delete :header
      attributes
    end
  end
end
