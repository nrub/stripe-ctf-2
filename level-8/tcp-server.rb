#!/usr/bin/ruby

require 'socket'

puts "Starting up server..."
server = TCPServer.new(58934)

$num = 0
$run = 0
$ports = []
$solutions = []
while (session = server.accept)
  Thread.start do

    p "--- #{$run}, #{$run % 4}, #{$num}"

    $ports.push(Integer(session.peeraddr[1]))

    if $run % 4 == 3
      $diff = $ports[-1] - $ports[0]
      #p "#{$num} #{$diff}"
      $ports = []
      $num += 1
      $solutions.push({:num=>$num,:diff=>$diff})
    end
    $run += 1

    if $num >= 10
      # order
      p $solutions
      $solutions.sort {|x, y| x[:diff] > y[:diff] }
      p $solutions
    end

  end
end

