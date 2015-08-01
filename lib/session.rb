require 'celluloid'
require 'termbox'
require 'colorize'

module Xibalba
  class Session
    include Celluloid
    include Celluloid::Logger

    attr_reader :socket

    class << self
      def create(socket)
        new(socket).create
      end
    end

    def initialize(socket)
      @socket = socket
    end

    def create
      info "* client connection from #{client_id} *"
      introduce_ourselves
      handle
    end

    def handle
      loop { socket.readpartial(4096) }
    rescue => e
      # Anything goes wrong in here and just disconnect
      disconnect
    end

    def disconnect
      info "* client #{client_id} disconnected *"
      @socket.close
    rescue IOError => e
      # Forcing a close on an open socket raises IOError :/
    end

    private
      def client_id
        @client_id ||= begin
          _, port, host = socket.peeraddr
          "#{host}:#{port}"
        end
      end

      def say(s, nap_time=1)
        socket.write s
        sleep nap_time
      end

      def introduce_ourselves
        clear
        say "Welcome to"
        3.times do
          say "."
        end
        newline
        say Xibalba::BANNER.colorize(:red)
        newline
        newline
        say "NOTHING HERE YET!\n"
        newline
        newline
        say "GO AWAY!\n"
        disconnect
      end

      def clear
        say "\033[2J\033[H", 0
      end

      def newline
        say "\033[E", 0
      end
  end
end
