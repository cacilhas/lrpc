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
server\register "add", (...) ->
    s = 0
    coroutine.yield!
    s += e for _, e in ipairs {...}
    s

pid = libc.fork!

if pid == 0
    server\serve!

else
    fp = io.open "server.pid", "w"
    fp\write pid
    fp\close!
