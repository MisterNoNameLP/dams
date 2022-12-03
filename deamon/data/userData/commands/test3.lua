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

--print(_M.lib.ut.tostring(_M))

--_M.startFileThread("TEST", "TEST_THREAD")
