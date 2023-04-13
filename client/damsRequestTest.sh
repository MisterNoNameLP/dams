#!/bin/lua

local timeout = 3
--local uri = "https://damsdev.namelessserver.net/"
local uri = "http://localhost:8023"

local http = require("http.request")

local request = http.new_from_uri(uri)
local resHeaders, resBody, resErr
local stream

request.headers:upsert(":method", "ACTION")
request.headers:upsert("request-format", "lua-table")
request.headers:upsert("response-format", "readable-lua-table")
request:set_body([[{
    action = "test",
    value = "test value"
}]])

resHeaders, stream = request:go()
if resHeaders == nil then
    io.stderr:write(tostring(stream))
    io.stderr:flush()
    os.exit(1)
end

print()
print("===HEADERS===")
for index, header in resHeaders:each() do
    print(index, header)
end

print()
print("===BODY===")
resBody, resErr = stream:get_body_as_string()
if not resBody or resErr then
    io.stderr:write(tostring(resErr))
    io.stderr:flush()
    os.exit(1)
end
print(resBody)
print()