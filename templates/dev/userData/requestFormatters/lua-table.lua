local rawRequestData = ...

local suc, response = env.lib.serialization.load(rawRequestData)

if suc ~= true then
    return suc
else
    return response
end