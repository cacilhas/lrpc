Client = assert require "lrpc.client"

client = Client "localhost"
resp = client\send "add", "2", "3"
assert resp == "5", "expected 5, got #{resp}"
print "test success"
