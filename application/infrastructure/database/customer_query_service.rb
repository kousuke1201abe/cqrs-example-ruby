# frozen_string_literal: true

class CustomerQueryService
  def initialize(db_conn)
    @db_conn = db_conn
  end

  def query_all
    @db_conn.db.prepare('SELECT * FROM customers').execute
  end
end
