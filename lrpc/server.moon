local *

socket = assert require "socket"
ser = assert require "ser"


--------------------------------------------------------------------------------
callbacksMT =
    __newindex: (k, v) =>
        local pass

        switch type v
            when "function"
                pass = true

            when "table"
                mt = getmetatable v
                pass = true if type mt.__call == "function"

            else
                pass = false

        assert pass, "expected function, got #{type v}"

        rawset @, k, v


--------------------------------------------------------------------------------
class
    new: (host="*", port=54000) =>
        @host, @port = host, port
        @coros = {}
        @callbacks = setmetatable {}, callbacksMT

    register: (name, obj) =>
        io.stderr\write "deprecated method register, use @callbacks table"
        @callbacks[name] = obj

    serve: =>
        @udp = socket.udp!
        @udp\setsockname @host, @port
        @udp\settimeout .125

        while true
            data, host, port = @udp\receivefrom!

            if data and #data > 0
                coro = coroutine.create -> @\dealwith data, :host, :port
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
        command = @callbacks[commandname]
        return @\senderror "unknown command #{commandname}", peer unless command

        params = [param for param in *data[2, ]]
        resp = {pcall -> command unpack params}
        return @\senderror resp[2] unless resp[1]

        -- Everything went alright
        @\respond [e for e in *resp[2, ]], peer


    respond: (resp, peer) =>
        pcall -> @udp\sendto "#{ser resp}\n", peer.host, peer.port


    senderror: (err, peer) =>
        pcall -> @udp\sendto "ERR: #{err}\n", peer.host, peer.port
