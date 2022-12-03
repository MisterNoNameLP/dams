--local _M = ...

--[[
print("TEST 3")

print("ARGS: ", ...)

io.write("TW")
io.flush()
io.write("TW2")

ldlog("LDLOG")

io.stdout:write("STDOUT")
io.stderr:write("STDERR")

io.flush()
]]
--print(_M)

--print(_M._I.lib.ut.tostring(_M))

--_M._I.startFileThread("TEST", "TEST_THREAD")
