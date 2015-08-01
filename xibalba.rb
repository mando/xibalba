module Xibalba

  PORT = 3000

  BANNER = %q(
      ____  ___ ___ __________    _____    ____    __________    _____
      \   \/  /|   |\______   \  /  _  \  |    |   \______   \  /  _  \
       \     / |   | |    |  _/ /  /_\  \ |    |    |    |  _/ /  /_\  \
       /     \ |   | |    |   \/    |    \|    |___ |    |   \/    |    \
      /___/\  \|___| |______  /\____|__  /|_______ \|______  /\____|__  /
            \_/             \/         \/         \/       \/         \/

  )

end

require 'colorize'
puts Xibalba::BANNER.colorize(:red)

require_relative 'lib/telnet_server'
Xibalba::TelnetServer.new(Xibalba::PORT).run
