require 'celluloid'
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
      loop {
        socket.readpartial(4096)
        say "You DIE."
        say "Sorry, this is " + "Xibalba".colorize(:red)
        say "Anything you do will kill you."
        say "Try again later!"
        disconnect
      }
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

      def write(s)
        socket.write s
      rescue
        # In case someone rudely disconnects while we're talking
      end

      def say(s, nap_time=1)
        write s + "\n"
        sleep nap_time
      end

      def introduce_ourselves
        clear
        write "Welcome to"
        3.times do
          say "."
        end
        newline
        say Xibalba::BANNER.colorize(:red)
        newline
        newline
        say "You find yourself standing in front of a super creepy cave."
        newline
        say "What do you want to do?", 0
        prompt
      end

      def clear
        write "\033[2J\033[H"
      end

      def newline
        write "\033[E"
      end

      def prompt
        write "> "
      end
  end
end
