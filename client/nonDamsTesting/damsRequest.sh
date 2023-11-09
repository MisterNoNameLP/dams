#!/bin/lua

local timeout = 3
--local uri = "https://damsdev.namelessserver.net/"
local uri = "http://127.0.0.1:8023/api/test"

local http = require("http.request")

local request = http.new_from_uri(uri)
local resHeaders, resBody, resErr
local stream

request.headers:upsert(":method", "GET")
request.headers:upsert("accept", "text/readable-lua-table")
request:set_body([[{"test1" : "T1", "test2":"T2"}]])

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