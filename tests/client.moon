local *

Client = assert require "lrpc.client"

client = Client "localhost"
resp = client\send "add", 1, 2, 3, 4
assert resp == 10, "expected 10, got #{resp}"
print "test success"
