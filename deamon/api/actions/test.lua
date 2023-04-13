response.testValue = request.value

--[[
log(tostring(_M), tostring(_E), tostring(_D), tostring(_I))

log("\n_M #################")
for i, v in pairs(_M) do
    log(i, v)
end

log("\n_M._I #################")
for i, v in pairs(_M._I) do
    log(i, v)
end

log("\n_M._E #################")
for i, v in pairs(_M._E) do
    log(i, v)
end


log("\n")
log(_E.dynDup)

]]

log("Some testing happening here")

local t = {}

t[5] = "org 5"

for c = 1, 10 do
    table.insert(t, tostring(c))
end

t[3] = nil
table.insert(t, "11")

debug.dump(t)

return response

