#!/bin/lua
package.path = "libs/?.lua;" .. package.path
local args = {...}

local action = args[1] or ""

local ut = require("UT")

local client = require("DamsClient").new({
    uri = "http://127.0.0.1:8023",
})

local suc, headers, response = client:request({
    action = action,
    value = "TEST",
}, {})

for c = 1, 0 do
    local suc, headers, response = client:request({
        action = action,
        value = "TEST",
    }, {})
end

print("\nSUC")
print(suc)
print("\nHEADERS")
print(ut.tostring(headers))
print("\nRESPONSE")
print(ut.tostring(response))

