local *

ffi = assert require "ffi"

ffi.cdef [[
    typedef int pid_t;
    pid_t fork();
]]

libc = ffi.load "libc"


--------------------------------------------------------------------------------

Server = assert require "lrpc.server"

server = Server!


--------------------------------------------------------------------------------

server.callbacks.sum = (...) ->
    s = 0
    c = #{...}
    for _, param in ipairs {...}
        coroutine.yield!
        s += param
    s, c


server.callbacks.fact = (n) ->
    f = 1
    while n > 0
        coroutine.yield!
        f *= n
        n -= 1
    f


--------------------------------------------------------------------------------

pid = libc.fork!

if pid == 0
    server\serve!

else
    fp = io.open "server.pid", "w"
    fp\write pid
    fp\close!
