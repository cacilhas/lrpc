local *

socket = assert require "socket"
ser = assert require "ser"


--------------------------------------------------------------------------------
class
    new: (server, port=54000, timeout=3) =>
        error "no server", 2 unless server
        @server = socket.dns.toip server
        @server = @server or server
        @port = port
        @udp = socket.udp!
        @udp\settimeout timeout

    send: (command, ...) =>
        data = ser {command, ...}
        @udp\sendto "#{data}\n", @server, @port
        response = @udp\receive!
        error "timeout", 2 unless response

        error (response\sub 6), 2 if response\match "^ERR: "
        unpack (loadstring response)!
