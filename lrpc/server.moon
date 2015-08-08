socket = assert require "socket"


--------------------------------------------------------------------------------
class
    new: (host="*", port=54000) =>
        @host, @port = host, port
        @registered = {}

    register: (name, obj) =>
        @registered[name] = obj

    serve: =>
        @udp = socket.udp!
        @udp\setsockname @host, @port

        while true
            data, host, port = @udp\receivefrom!
            @\dealwith data, {:host, :port} if data and #data > 0

    dealwith: (data, peer) =>
        parser = data\gmatch "%S+"
        command = @registered[parser!]
        local resp

        if command
            params = [param for param in parser]
            status, resp = pcall -> command unpack params
            resp = "ERR: #{resp}" unless status
        else
            resp = "ERR: unknown command"

        pcall -> @udp\sendto "#{resp}\n", peer.host, peer.port
