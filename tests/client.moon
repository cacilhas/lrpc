local Client
export ^
local *

unit = assert require "luaunit"
Client = assert require "lrpc.client"
Server = assert require "lrpc.server"


--------------------------------------------------------------------------------
reduce = (op, acc, n, ...) ->
    return acc if n == nil
    reduce op, (op acc, n), ...


client = Client "localhost"


--------------------------------------------------------------------------------
TestRPC =
    testSum: =>
        expected = reduce ((a, b) -> a + b), 1, 2, 3, 4
        resp, count = client\send "sum", 1, 2, 3, 4
        unit.assertEquals resp, expected
        unit.assertEquals count, 4

    testFact: =>
        expected = 120
        resp = client\send "fact", 5
        unit.assertEquals resp, expected

    testUnregistered: =>
        expected = ": unknown command unknown"
        unit.assertErrorMsgContains expected, client\send, "unknown", "data"

    testExpectFunction: =>
        server = Server "localhost", 54001
        expected = ": expected function, got string"
        unit.assertErrorMsgContains expected, -> server.callbacks.some = "some"

        server.callbacks.a = -> nil
        server.callbacks.b = setmetatable {}, __call: () => nil


--------------------------------------------------------------------------------
os.exit unit.LuaUnit.run!
