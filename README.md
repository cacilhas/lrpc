# LRPC

A spartan example of RPC over UDP, powered by
[MoonScript](http://moonscript.org/) and [LuaJIT](http://luajit.org).


## Dependencies

LRPC requires [LuaSocket](http://w3.impa.br/~diego/software/luasocket/). Be
careful when compiling it, remember to use LuaJIT headers and libs instead of
traditional Lua.

Indeed, in the current release, LRPC shall work over traditional Lua, but it’s
not tested.

I’ve opted for LuaSocket so LRPC can be used in [LÖVE](https://love2d.org/).


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
#!moonscript

Server = assert require "lrpc.server"
server = Server!

server.callbacks.add = (a, b) -> a + b
server\serve!
```

The `Server` constructor accepts two parameters:

* The first is the IP to listen, defaults to `"*"`;
* The second is the port, defaults to `54000`.

Note: use `coroutine.yield` on callback’s loops to release server for handling
other connections.


### The client

```
#!moonscript

Client = assert require "lrpc.client"
client = (Client "localhost").remote

print client.add 2, 3
```

The `Client` constructor accepts two parameters:

* The first is the host to connect, no default value;
* The second is the port, defaults to `54000`.


## Author

[ℜodrigo Arĥimedeς ℳontegasppa ℭacilhας](mailto:batalema@cacilhas.info)
