# frozen_string_literal: true

require 'socket'

client_server = TCPServer.new(12_345)  # Port for client.rb
command_server = TCPServer.new(12_346) # Port for command_requester.rb
clients = {}
thread_names = ('a'..'z').to_a
next_thread_name_index = 0

# Thread for communication with clients
Thread.new do
  loop do
    puts '[client_server] Waiting for a connection...'
    client_socket, = client_server.accept
    thread_name = thread_names[next_thread_name_index]
    puts "[client_server] Connected! Thread name: #{thread_name}"
    next_thread_name_index += 1

    clients[thread_name] = {
      thread: Thread.new do
        while (message = client_socket.gets)
          puts "[client_server] Received: #{message}"
          client_socket.puts message
        end
      end,
      socket: client_socket
    }
  end
end

# Thread for communication with command requester
Thread.new do
  loop do
    puts '[command_server] Waiting for a connection...'
    client = command_server.accept
    puts '[command_server] Connected!'

    Thread.start(client) do |socket|
      while (message = socket.gets)
        puts "[command_server] Received: #{message}"
        thread_id, text = message.chomp.split(':', 2)
        puts "[command_server] Sending to #{thread_id}: #{text}"
        puts "[command_server] clients: #{clients}"
        puts "[command_server] client: #{clients[thread_id]}"
        puts "[command_server] socket: #{clients[thread_id][:socket]}"

        if clients[thread_id]
          clients[thread_id][:socket].puts text
        else
          puts "No such thread: #{thread_id}"
        end
      end
    end
  end
end

loop do
  sleep 1
end
