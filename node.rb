require 'socket'
require 'json'
class SearchResult

  def initialize
    @words = ["component"]
    @frequency = 0
    @url = "http://www.google.com"
  end

  def words
    @words
  end

  def url
    @url
  end

  def frequency
    @frequency
  end
end


class Node
  def init( sock)
    @socket = sock
    @node_id = 1
    @ip_address = "127.0.0.1"
    @gateway_id = 22

  end


  def joinNetWork(bootstrap)

  end

  def leaveNetwork(networkId)
    result = false
  end

  def indexPage(url, unique_words)

  end

  def search(words)

  end

  def sendMessageToSelf

    message = generateMessage("JOINING_NETWORK")
    @socket.send message, 0, "127.0.0.1", 4913

  end

  def generateMessage(type)

    case type
      when "JOINING_NETWORK"
        msg = JSON.generate(type:type, node_id:@node_id, ip_address:@ip_address)

      when "JOINING_NETWORK_RELAY"


      when "ROUTING_INFO"


      when "LEAVING_NETWORK"


      when "INDEX"


      when "SEARCH"


      when "SEARCH RESPONSE"


      when "PING"


      when "ACK"

    end

  end

  def receiveInput
    received_packet = @socket.recvfrom(1000)
    parsed = JSON.parse(received_packet[0])
    puts parsed
  end

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

  def hashCode(string_to_hash)
    hash = 0

    for i in 0...string_to_hash.length
      hash = hash*31+string_to_hash[i].ord
    end
    return hash
  end
end


sock = UDPSocket.new
sock.bind("127.0.0.1", 4913)
nd = Node.new
nd.init(sock)
nd.sendMessageToSelf
nd.receiveInput

