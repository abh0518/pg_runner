require 'pg'

module PG

  class IConnectionPool
    attr_reader :size
    def get_conn
    end
    def release_conn( conn )
    end
  end

  class SingleConnectionPool < IConnectionPool
    def initialize( conn )
      @conn = conn
      @size = 1
    end

    def get_conn
      @conn
    end
  end

  # Connection Pool Class for PGRunner
  class BasicConnectionPool < IConnectionPool

    DEFAULT_CONNECTION_COUNT = 5
    DEFAULT_WAITING_TIME = 0.001

    def initialize( host, port, database, username, password, pool_size = DEFAULT_CONNECTION_COUNT )
      @lock = Mutex.new
      @host, @port, @database, @username, @password = host, port, database, username, password
      prepare_pool ( pool_size )
    end

    def get_conn
      conn = nil
      @lock.synchronize do
        while( @idle_pool.empty? )
          sleep( DEFAULT_WAITING_TIME )
        end
        conn = @idle_pool.get
      end

      begin
        conn.exec("SELECT 1")
      rescue
        begin
          conn = PG::Connection.new( @host, @port, nil, nil, @database, @username, @password )
        rescue Exception => e
          @idle_pool.put( conn )
          raise e
        end
      end

      @active_pool.put conn
      conn
    end

    def release_conn( conn )
      @active_pool.delete( conn )
      @idle_pool.put( conn )
    end

    private

    def prepare_pool( pool_size )
      @size = pool_size
      @idle_pool = SynchronizedObjectPool.new
      @active_pool = SynchronizedObjectPool.new
      pool_size.times do
        conn = PG::Connection.new( @host, @port, nil, nil, @database, @username, @password )
        @idle_pool.put( conn )
      end
    end

    class SynchronizedObjectPool
      public
      def initialize
        @lock = Mutex.new
        @pool = []
      end

      def put( conn )
        @lock.synchronize do
          @pool << conn
        end
      end

      def get
        @lock.synchronize do
          conn = @pool.pop
        end
      end

      def delete( conn )
        @lock.synchronize do
          @pool.delete ( conn )
        end
      end

      def empty?
        @pool.empty?
      end

      def size
        @pool.size
      end
    end
  end

end


