#pg_runner

## About pg_runner
Providing connection pool and easy query tools for postgresql

## Required Gems

- postgres

      gem install postgres

## Class 

- PG::RunnerConnectionPool 
    
      A database connection pool for postgresql
    
- PG::PGRunner

      A simple sql executer class
    

## Example Code

    connection_pool = PG::RunnerConnectionPool.new( dbhost, port, dbname, username, password )
    pg_runner = PG::PGRunner.new( connection_pool )
    pg_runner.exec_sql ( "SELECT 1" )