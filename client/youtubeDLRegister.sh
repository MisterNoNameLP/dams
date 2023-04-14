#!/bin/pleal
package.path = "libs/?.lua;" .. package.path
local args = {...}

local ut = require("UT")
local client = require("DamsClient").new({
	uri = "http://127.0.0.1:8023",
})

local suc, headers, response = client:request({
	action = "youtubedl/register",
	token = "hdB5MaLdqlQ7lBJK\$s5IE6L3cagZOl8m9q8NNnD7aJVOzDKJ9",
	--token = "ebxuFFbJ56VzMJRh\$mHPqunj20DLZjqo1IMQadPB2vx6AnSso",
	url = "TEST_URI",
	interval = 10,
}, {})

print("\nSUC")
print(suc)
print("\nHEADERS")
print(ut.tostring(headers))
print("\nRESPONSE")
print(ut.tostring(response))

