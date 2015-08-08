# LRPC

A spartan example of RPC over UDP, powered by
[MoonScript](http://moonscript.org/) and [LuaJIT](http://luajit.org).


## Dependencies

LRPC requires [LuaSocket](http://w3.impa.br/~diego/software/luasocket/). Be
careful when compiling it, remember to use LuaJIT headers and libs instead of
traditional Lua.

Indeed, in the current release, LRPC shall work over traditional Lua, but I’ve
not tested it.


## Installing

```
#!bash

make
make test
sudo make install
```


## Use

### The server

```
#!lua

local Server = assert(require "lrpc.server")
local server = Server()

server.register("add", function(a, b)
  return 0 + a + b
end)

server.serve()
```

The `Server` constructor accepts two parameters:

* The first is the IP to listen, default `"*"`;
* The second is the port, default `54000`.


### The client

```
#!lua

local Client = assert(require "lrpc.client")
local client = Client "localhost"

print(client.send("add", "2", "3"))
```

The `Client` constructor accepts three parameters:

* The first is the host to connect, no default value;
* The second is the port, default `54000`;
* The third is the timeout in seconds, default no timeout.


## Author

[ℜodrigo Arĥimedeς ℳontegasppa ℭacilhας](mailto:batalema@cacilhas.info)
