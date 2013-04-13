require 'pg'
require File.join( File.dirname( __FILE__ ), "basic_connection_pool" )

module PG

  # a tool class to execute sql for postgresql, no need to manage db connections.
  # this tool is needed developing trasaction function
  class SqlRunner
    def initialize(connection_pool)
      @conn_pool = connection_pool
    end

    def transaction( &block )
      connect do | conn |
        conn.transaction do | conn |
          yield SqlRunner.new(SingleConnectionPool.new( conn ))
        end
      end
    end

    def query( sql )
      connect do | conn |
        conn.exec( sql )
      end
    end

    private

    def connect( &block )
      begin
        conn = @conn_pool.get_conn
        yield conn
      ensure
        @conn_pool.release_conn( conn )
      end
    end
  end



end

