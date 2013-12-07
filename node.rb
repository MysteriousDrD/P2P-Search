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

  def sendMessageToSelf(msg_type)

    message = generateMessage(msg_type)
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
  end

  def handleInput
    received = receiveInput
    type = received['type']

    case type
      when "JOINING_NETWORK"
        puts type

      when "JOINING_NETWORK_RELAY"
        puts type

      when "ROUTING_INFO"
        puts type

      when "LEAVING_NETWORK"
        puts type

      when "INDEX"
        puts type

      when "SEARCH"
        puts type

      when "SEARCH RESPONSE"
        puts type

      when "PING"
        puts type

      when "ACK"
        puts type

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
nd.sendMessageToSelf("PING")
nd.handleInput

