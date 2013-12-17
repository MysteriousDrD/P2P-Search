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
  def init( sock, id, ip, port)
    @socket = sock
    @node_id = id
    @ip_address = ip
    @gateway_id = 22
    @port = port
    @time = Time.now.to_f
    @AckList = Hash.new

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

  def sendMessage(msg_type, port, target)

    message = generateMessage(msg_type, target)
    @socket.send message, 0, @ip_address, port

  end

  def generateMessage(type, target)

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
        msg = JSON.generate(type:type, target_id:target, sender_id:@node_id, ip_address:@port)


      when "ACK"
        msg = JSON.generate(type:type, node_id:@node_id, ip_address:@port)

    end

  end

  def receiveInput

    received_packet = @socket.recvfrom(1000)
    parsed = JSON.parse(received_packet[0])
  end

  def countUntilTimeout(id)
    puts "starting timeout counter for node"
    while @AckList[id] do
      if Time.now.to_f - @time > 10 then
        puts "Timeout done: #{id} should be removed from routing table"
        #some code to remove node from routing table
        @AckList[id] = FALSE
      end
    end
  end

  def handleInput
    begin

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
          if received['target_id'] == @node_id then

            sendMessage("ACK",received['ip_address'], received['sender_id'] )



          else
            puts "Node #{@node_id} passing it on"
            #should be pinging next node in the routing table from here
            sendMessage("ACK",received['ip_address'], received['sender_id'] )
            time = Time.now.to_f
            puts "timestamp: #{time}"
            target = received['target_id'] #this should be the next node in the routing table
            @AckList[target] = true
            Thread.new{countUntilTimeout(target)} #start a threaded counter NB this only works for one timeout at a time
          end



        when "ACK"
          puts "Node #{@node_id} received ACK"
          @AckList[target] = FALSE
          #should stop a counter here

        else
          puts "invalid message"
      end
   end while 1
  end

  def hashCode(string_to_hash)
    hash = 0

    for i in 0...string_to_hash.length
      hash = hash*31+string_to_hash[i].ord
    end
    return hash
  end
end

port = 8767
sock = UDPSocket.new
sock.bind("127.0.0.1", port)
nd = Node.new
nd.init(sock, 1, "127.0.0.1", port)



port2 = 8766
sock2 = UDPSocket.new
sock2.bind("127.0.0.1", port2)
nd2 = Node.new
nd2.init(sock2, 10, "127.0.0.1", port2)

t1= Thread.new{nd.handleInput}
t2 = Thread.new{nd2.handleInput}

nd.sendMessage("PING",port2, 11)

t1.join
t2.join