require 'pg'
require File.join( File.dirname( __FILE__ ), "basic_connection_pool" )

module PG

  # a wrapping class to execute sql for postgresql, no need to manage db connections.
  class SqlRunner

    def initialize(connection_pool)
      @conn_pool = connection_pool
    end

    #def prepare( name, sql )
    #  self.connect do | conn |
    #     conn.prepare( name, sql )
    #  end
    #end

    def transaction( &block )
      connect do | conn |
        conn.transaction do | conn |
          yield SqlRunner.new(SingleConnectionPool.new( conn ))
        end
      end
    end

    def query( sql, param = nil, &block )
      connect do | conn |
        rs = conn.exec_params( sql, param )
        yield rs if !block.nil?
        rs
      end
    end

    # call this method to work with PG::Connection.
    def connect( &block )
      conn = @conn_pool.get_conn
      yield conn
    ensure
      @conn_pool.release_conn( conn )
    end

  end
end

