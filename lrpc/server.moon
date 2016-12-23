local *

socket = assert require "socket"
ser = assert require "ser"


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
        parser, err = loadstring data
        return @\senderror err, peer unless parser

        data = parser!
        commandname = data[1]
        command = @registered[commandname]
        return @\senderror "unknown command #{commandname}", peer unless command

        params = [param for param in *data[2, ]]
        resp = {pcall -> command unpack params}
        return @\senderror resp[2] unless resp[1]

        -- Everything went alright
        @\respond [e for e in *resp[2, ]], peer


    respond: (resp, peer) =>
        status, err = pcall -> @udp\sendto "#{ser resp}\n", peer.host, peer.port


    senderror: (err, peer) =>
        pcall -> @udp\sendto "ERR: #{err}\n", peer.host, peer.port