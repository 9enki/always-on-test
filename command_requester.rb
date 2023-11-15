# frozen_string_literal: true

require 'socket'

# Connect to a.rb
socket = TCPSocket.new('localhost', 12_346)

loop do
  puts 'Enter the thread ID and message to send (Format: id:message):'
  message = gets.chomp
  socket.puts message
end
