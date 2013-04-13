#pg_runner

## About pg_runner
Providing connection pool and easy query tools for postgresql

## Required Gems

- postgres

      gem install postgres

## Class 

- PG::BasicConnectionPool
    
      A database connection pool for postgresql

- PG::SingleConnectionPool

      A database connection pool suppoert only one connection for postgresql
      this is a fake connection pool for transaction function of SqlRunner

- PG::SqlRunner

      A simple sql executer class
    

## Example Code

### create connection pool and runner

    connection_pool = PG::BasicConnectionPool.new( dbhost, port, dbname, username, password )
    runner = PG::SqlRunner.new( connection_pool )

### basic usage

    rs = runner.query( "select 1" )
    rs.each do | row |
      # do something
    end

    rs = runner.query( "update blabla" )
    # result is PGresult class of pg gem
    if rs.cmd_tuples < 1
        # blabla~
    end

### transaction

    runner.transaction do | runner |
        # do some transaction works with runner
        # raise Exception if you want rollback
    end

