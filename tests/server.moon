Server = assert require "lrpc.server"

server = Server!
server\register "add", (a, b) ->
    coroutine.yield!
    tostring 0 + a + b

server\serve!
