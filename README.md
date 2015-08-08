# LRPC

A spartan example of RPC over UDP, powered by
[MoonScript](http://moonscript.org/) and [LuaJIT](http://luajit.org).


## Dependencies

LRPC requires [LuaSocket](http://w3.impa.br/~diego/software/luasocket/). Be
careful when compiling it, remember to use LuaJIT headers and libs instead of
traditional Lua.


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


### The client

```
#!lua

local Client = assert(require "lrpc.client")
local client = Client "localhost"

print(client.send("add", "2", "3"))
```


## Author

[ℜodrigo Arĥimedeς ℳontegasppa ℭacilhας](mailto:batalema@cacilhas.info)
