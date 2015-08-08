socket = assert require "socket"


--------------------------------------------------------------------------------
class
    new: (server, port=54000) =>
        error "no server" unless server
        @server = socket.dns.toip server
        @server = @server or server
        @port = port
        @udp = socket.udp!

    send: (command, ...) =>
        params = {command, ...}
        data = table.concat params, " "
        @udp\sendto "#{data}\n", @server, @port
        response = @udp\receivefrom!
        response = response\gsub "(.-)%s*$", "%1"

        raise response if response\match "^ERR: "
        response
