#pg_runner

## About pg_runner
Providing connection pool and easy query tools for postgresql

## Required Gems

- postgres

      #reference site
      #https://github.com/ged/ruby-pg
      #https://bitbucket.org/ged/ruby-pg/wiki/Home

      #install gem
      gem install pg

## Class 

- PG::BasicConnectionPool
    
      A database connection pool for postgresql. default pool size is 5.

- PG::SingleConnectionPool

      A database connection pool supporting only one connection for postgresql
      this is a fake connection pool for the transaction function of SqlRunner

- PG::SqlRunner

      A simple sql executer class
    

## Example Code

### create connection pool and runner

    connection_pool = PG::BasicConnectionPool.new( dbhost, port, dbname, username, password, pool_sise(optional) )
    runner = PG::SqlRunner.new( connection_pool )

### Simple query

    # query
    rs = runner.query( "select 1" )
    rs.each do | row |
      # do something
    end

    # query with block
    rs = runner.query( "select * from blabla where $1 = 1" ) do | result |
      # do something
    end


    # query with params
    rs = runner.query( "select $1" , [1] )

    # query with params & block
    rs = runner.query( "select * from blabla where $1 = 1" , [1] ) do | result |
      # do something
    end

### Transaction

    runner.transaction do | runner |
        # do some transaction works with runner
        # raise Exception if you want rollback
    end

### Work through PG::Connection

    # work with PG::Connection
    runner.connect do | conn | do
      # bla bla~
    end

