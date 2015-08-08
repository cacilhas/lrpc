Server = assert require "lrpc.server"

server = Server!
server\register "add", (a, b) ->
    tostring 0 + a + b

server\serve!
