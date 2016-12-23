local *

socket = assert require "socket"
ser = assert require "ser"


remoteMT =
    __index: (command) =>
        (...) -> @client\send command, ...

    __newindex: (k, v) =>
        error "cannot set remote attributes"


--------------------------------------------------------------------------------
class
    new: (server, port=54000, timeout=3) =>
        error "no server supplied", 2 unless server
        @server = socket.dns.toip server
        @server = @server or server
        @port = port
        @remote = setmetatable {client: @}, remoteMT
        @udp = socket.udp!
        @udp\settimeout timeout

    send: (command, ...) =>
        data = ser {command, ...}
        @udp\sendto "#{data}\n", @server, @port
        response = @udp\receive!
        error "timeout", 2 unless response

        if response\match "^ERR: "
            response = ((response\sub 6)\gsub "^%s+", "")\gsub "%s+$", ""
            error response, 2
        else
            unpack (loadstring response)!
