require 'celluloid/io'
require 'celluloid/autostart'

require_relative 'session'

module Xibalba
  class TelnetServer
    include Celluloid::IO
    include Celluloid::Logger

    finalizer :shutdown

    def initialize(port)
      info "** Starting server on port #{port} **"
      @server = TCPServer.new(port)
    end

    def shutdown
      @server.close if @server
    end

    def run
      loop { async.handle_connection @server.accept }
    end

    def handle_connection(socket)
      Session.create(socket)
    rescue IOError
    end
  end
end
