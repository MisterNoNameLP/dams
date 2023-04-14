#!/bin/lua
package.path = "libs/?.lua;" .. package.path

local ut = require("UT")

local client = require("DamsClient").new({
    uri = "https://damsdev.namelessserver.net",
})

local headers, response = client:request({
    action = "test",
    value = "TEST",
})

print(ut.tostring(response))

