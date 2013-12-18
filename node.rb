require 'socket'
require 'json'
class SearchResult

  def initialize
    @frequency = 0
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
  def init( sock, port)
    @socket = sock
    @gateway_id = hashCode("component")
    @time = Time.now.to_f
    @AckList = Hash.new
    @Routing = Hash.new
    @ip_address = "127.0.0.1"
    @ownPort = port
    @Results = Hash.new
    @ResultsLinks = Hash.new

  end

  def predefinedSetup
    @Routing[hashCode("component")] = @ownPort
    @node_id = hashCode("component")
  end


  def printRoutes
    puts @Routing
  end

  def joinNetwork(bootstrap, identifier, target)
    @gateway_id = 22
    @node_id = hashCode(identifier)
    targetNode = hashCode(target)

    message = JSON.generate(type:"JOINING_NETWORK_SIMPLIFIED", node_id:@node_id, target_id:target, ip_address:@ownPort)
    puts message
    @socket.send message, 0, @ip_address, bootstrap #this is temporarily a port


  end

  def leaveNetwork(networkId)
    result = false
  end

  def indexPage(url, unique_words)
    sendIndex(@Routing[hashCode(unique_words)], @node_id, unique_words, url)

  end

  def search(words)

  end

  def sendPing(target, port) #sender comes from the node itself
    message = JSON.generate(type:"PING", target_id:hashCode(target), sender_id:@node_id, ip_address:port)
    time = Time.now.to_f
    puts "timestamp: #{time}"
    @AckList[hashCode(target)] = true
    Thread.new{countUntilTimeout(hashCode(target))}
    @socket.send message,0, @ip_address, @Routing[hashCode(target)]
  end

  def sendAck(sender)
    message = JSON.generate(type:"ACK" ,node_id:@node_id, ip_address:@ownPort)
    @socket.send message,0,@ip_address, sender
  end

  def sendRoutingInfo(joiner)
    message = JSON.generate(type:"ROUTING_INFO", gateway_id:hashCode("component"), node_id:joiner,ip_address:@ownPort,
    route_table:@Routing.to_json)
    @socket.send message,0,@ip_address, joiner
  end

  def sendMessage(msg_type, port, target)

    message = generateMessage(msg_type, target, 0)
    @socket.send message, 0, @ip_address, port

  end

  def sendIndex(target, sender, word, links)
    message = JSON.generate(type:"INDEX", target_id:target, sender_id:sender, keyWord:word, link:links)
    @socket.send message,0, @ip_address, @Routing[hashCode(word)]
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
        @Routing.delete(id)
        @AckList[id] = FALSE
      end
    end
    puts "timeout didn't expire"
  end

  def handleInput
    begin
      received = receiveInput
      type = received['type']

      case type
        when "JOINING_NETWORK_SIMPLIFIED"
          info = received['node_id']
          address = received['ip_address']
          puts address
          puts info
          @Routing[info] = address
          puts @Routing
          sendRoutingInfo(address)
          #printRoutes
          puts "added info to routing table "

        when "JOINING_NETWORK_RELAY"
        #  puts type

        when "ROUTING_INFO"
          routing = received['route_table']
          #puts "Table before: #{@Routing}"
          hashes =  JSON.parse(routing) #add hashes to routing table
          hashes.each do |key, val|
            @Routing[key] = val
          end
         # puts "Table after (for #{@ownPort}: #{@Routing}"

        when "LEAVING_NETWORK"
          puts type

        when "INDEX"
          #need to store results here
          puts type
          word = received['keyWord']
          url = received['link']

          if @ResultsLinks.has_key?(url) == FALSE then
            @ResultsLinks[url] = 0
          end
          @ResultsLinks[url] = @ResultsLinks[url] + 1
          @Results[word] = @ResultsLinks

          puts @ResultsLinks
          puts @Results











        when "SEARCH"
          puts type

        when "SEARCH RESPONSE"
          puts type

        when "PING"
          if received['target_id'] == @node_id then
            puts "sending ack to #{received['ip_address']} "
            sendAck(received['ip_address'])
            puts "ack sent "




          else #this never happens with my implementation
            puts "Node #{@node_id} passing it on"
            #should be pinging next node in the routing table from here
            time = Time.now.to_f
            puts "timestamp: #{time}"
            target = received['target_id'] #this should be the next node in the routing table
            @AckList[target] = true
            Thread.new{countUntilTimeout(hashCode(target))}
          end



        when "ACK"
          puts "Node #{@node_id} received ACK"
          target = received['node_id']
          puts target
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
nd.init(sock, port)
nd.predefinedSetup

port2 = 8766
sock2 = UDPSocket.new
sock2.bind("127.0.0.1", port2)
nd2 = Node.new
nd2.init(sock2, port2)

port3 = 8765
sock3 = UDPSocket.new
sock3.bind("127.0.0.1", port3)
nd3 = Node.new
nd3.init(sock3, port3)

t1= Thread.new{nd.handleInput}
t2 = Thread.new{nd2.handleInput}
t3 = Thread.new{nd3.handleInput}
nd2.joinNetwork(port, "apple", "component")
nd3.joinNetwork(port, "orange", "component")
nd3.printRoutes


sleep(0.5)
puts "routes: "
nd.printRoutes
nd.sendPing("apple", 8767)
nd.indexPage("http://meh.com", "apple")
nd.indexPage("http://meh.com", "apple")
t1.join
t2.join
