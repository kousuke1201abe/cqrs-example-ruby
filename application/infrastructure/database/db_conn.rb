class DBConn
  attr_reader :db

  def initialize
    @db = Mysql2::Client.new(
      host: 'db',
      username: 'root',
      password: 'password',
      database: 'cqrs_example'
    )
  end

  def transaction
    raise ArgumentError, 'No block was given' unless block_given?

    begin
      @db.query('BEGIN')
      yield
      @db.query('COMMIT')
    rescue StandardError => e
      puts(e)
      @db.query('ROLLBACK')
    end
  end
end
