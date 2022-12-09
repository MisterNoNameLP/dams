local osDirPath = "./core/os/"
local len = require("utf8").len

return function(cmd, ...)
    local path = _M._I.ut.seperatePath(cmd)
    cmd = cmd:sub(len(path))

    cmd = "cd " .. osDirPath .. path .. "; ./" .. cmd

    return exec(cmd, ...)
end