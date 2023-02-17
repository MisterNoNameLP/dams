#!/bin/lua
package.path = "libs/?.lua;" .. package.path

local ut = require("UT")

local client = require("DamsClient").new({
    uri = "http://127.0.0.1:8023",
})

local suc, headers, response = client:request({
    action = "plealTest",
    value = "TEST",
}, {})

for c = 1, 0 do
    local suc, headers, response = client:request({
        action = "ptest",
        value = "TEST",
    }, {})
end

print("\nSUC")
print(suc)
print("\nHEADERS")
print(ut.tostring(headers))
print("\nRESPONSE")
print(ut.tostring(response))

