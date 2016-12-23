local *

Client = assert require "lrpc.client"

reduce = (op, acc, n, ...) ->
    return acc unless n
    reduce op, (op acc, n), ...

client = Client "localhost"

do -- first registered function
    expected = reduce ((a, b) -> a + b), 1, 2, 3, 4
    resp, count = client\send "sum", 1, 2, 3, 4
    assert resp == expected, "expected #{expected}, got #{resp}"
    assert count == 4, "expected 4 parameters, got #{count}"

do -- second registered function
    expected = 120
    resp = client\send "fact", 5
    assert resp == expected, "expected #{expected}, got #{resp}"

do -- unregistered function
    expected = "tests/client.moon:25: unknown command unknown"
    status, err = pcall -> client\send "unknown", "data"
    assert not status, "expected error"
    assert err == expected, "expected `#{expected}', got `#{err}'"

print "test success"
