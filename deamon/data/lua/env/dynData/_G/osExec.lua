local osDirPath = "./data/os/"
local len = require("utf8").len

return function(cmd, ...)
    local path = _E.ut.seperatePath(cmd)
    cmd = cmd:sub(len(path))

    cmd = "cd " .. osDirPath .. path .. "; ./" .. cmd

    return exec(cmd, ...)
end