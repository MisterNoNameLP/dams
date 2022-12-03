local rawRequestData = ...

--BUG; DANGEROUS; CRUCIAL; executing the request opens a door to execute harmful code!

local suc, response = _M._I.lib.serialization.load(rawRequestData)


--[[
print("=====================")
--local ts = "{f = function() return 'HARM' end}"
--local ts = "local t = 0; for c = 0, 10 do t = t +1; end"
local ts = "do local t = 0; for c = 0, 10 do t = t -1; end; return t end"

log("LOAD: ", _M._I.lib.serialization.load(ts))
local _, res = _M._I.lib.serialization.load(ts)

log("DUMP")
print(_M._I.ut.tostring(res))

--print(pcall(res.f))
log("EXEC:")
print(pcall(res))
]]


if suc ~= true then
    return suc
else
    return response
end