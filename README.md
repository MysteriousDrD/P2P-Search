P2P-Search
==========

for distributed systems coursework


note for marking:

Everything except for routing seems to work, if routing table info is set up for each node then all implemented functions will work as expected. Using the existing joining method allows for requests etc to work as long as you route them through the bootstrap node, who has info on all the other nodes by design.

NB: Instead of using unique IP addresses (as this code was mostly written before the spec change to INETSocketAddress) UDP sockets with unique ports are passed in instead, I just haven't changed it because I'm using this code to test and I don't want to corrupt my repo with code I can't actually use/test, so running the .rb file on a local machine will work just fine. Routing table contains port data instead of IP addresses too.

One small feature that got left out was ACK_INDEX responses, I just forgot to do that, and have run out of time, that's all.