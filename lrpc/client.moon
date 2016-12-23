local *

socket = assert require "socket"


--------------------------------------------------------------------------------
class
    new: (server, port=54000, timeout=3) =>
        error "no server" unless server
        @server = socket.dns.toip server
        @server = @server or server
        @port = port
        @udp = socket.udp!
        @udp\settimeout timeout

    send: (command, ...) =>
        params = {command, ...}
        data = table.concat params, " "
        @udp\sendto "#{data}\n", @server, @port
        response = @udp\receive!
        response = response\gsub "(.-)%s*$", "%1"

        raise response if response\match "^ERR: "
        response
