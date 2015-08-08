socket = assert require "socket"


--------------------------------------------------------------------------------
class
    new: (host="*", port=54000) =>
        @host, @port = host, port
        @coros = {}
        @registered = {}

    register: (name, obj) =>
        @registered[name] = obj

    serve: =>
        @udp = socket.udp!
        @udp\setsockname @host, @port
        @udp\settimeout .125

        while true
            data, host, port = @udp\receivefrom!

            if data and #data > 0
                coro = coroutine.create -> @\dealwith data, {:host, :port}
                @coros["#{host}:#{port}"] = coro

            for name, coro in pairs @coros
                if (coroutine.status coro) == "dead"
                    @coros[name] = nil
                else
                    coroutine.resume coro


    dealwith: (data, peer) =>
        parser = data\gmatch "%S+"
        commandname = parser!
        command = @registered[commandname]
        local resp

        if command
            params = [param for param in parser]
            status, resp = pcall -> command unpack params
            resp = "ERR: #{resp}" unless status
        else
            resp = "ERR: unknown command #{commandname}"

        pcall -> @udp\sendto "#{resp}\n", peer.host, peer.port
