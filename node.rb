class Node
  def handleInput
    bar = "ROUTING_INFO" #this will be read in from other nodes later

    case bar
      when "JOINING_NETWORK"
        puts bar

      when "JOINING_NETWORK_RELAY"
        puts bar

      when "ROUTING_INFO"
        puts bar

      when "LEAVING_NETWORK"
        puts bar

      when "INDEX"
        puts bar

      when "SEARCH"
        puts bar

      when "SEARCH RESPONSE"
        puts bar

      when "PING"
        puts bar

      when "ACK"
        puts bar

      else
        puts "invalid message"
    end

  end
end
