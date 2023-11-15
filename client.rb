# frozen_string_literal: true

require 'socket'

# Connect to a.rb
socket = TCPSocket.new('localhost', 12_345)

puts 'Connected!'

loop do
  if (message = socket.gets)
    puts "Received: #{message}"
  end
end
