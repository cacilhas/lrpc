socket = assert require "socket"


--------------------------------------------------------------------------------
class
    new: (server, port=54000, timeout) =>
        error "no server" unless server
        @server = socket.dns.toip server
        @server = @server or server
        @port = port
        timeout = nil if (type timeout) == "number" and timeout <= 0
        @udp = socket.udp!
        @udp\settimeout timeout if timeout

    send: (command, ...) =>
        params = {command, ...}
        data = table.concat params, " "
        @udp\sendto "#{data}\n", @server, @port
        response = @udp\receivefrom!
        response = response\gsub "(.-)%s*$", "%1"

        raise response if response\match "^ERR: "
        response
