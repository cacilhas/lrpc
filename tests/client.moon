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
        resp, count = client.remote.sum 1, 2, 3, 4
        unit.assertEquals resp, expected
        unit.assertEquals count, 4

    testFact: =>
        expected = 120
        resp = client.remote.fact 5
        unit.assertEquals resp, expected

    testUnregistered: =>
        expected = ": unknown command unknown"
        unit.assertErrorMsgContains expected, client.remote.unknown, "data"

    testNotReset: =>
        expected = ": cannot set remote attributes"
        unit.assertErrorMsgContains expected, -> client.remote.other = true

    testExpectFunction: =>
        server = Server "localhost", 54001
        expected = ": expected function, got string"
        unit.assertErrorMsgContains expected, -> server.callbacks.some = "some"

        server.callbacks.a = -> nil
        server.callbacks.b = setmetatable {}, __call: () => nil


--------------------------------------------------------------------------------
os.exit unit.LuaUnit.run!
