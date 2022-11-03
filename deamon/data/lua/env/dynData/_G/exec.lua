local len = require("utf8").len

return function(cmd, envTable, secret)
    local execString = ""
    local handlerFile, output
    local returnSignal
    
    if envTable then
        execString = execString .. env.dyn.sh.envSetup(envTable)
    end
    execString = execString .. " " .. cmd .. "; printf \"\n$?\""

    if secret ~= true then
        debug.exec("Execute cmd: " .. execString)
    end
    handlerFile = io.popen(execString, "r")
    output = handlerFile:read("*a")
    handlerFile:close()

    for s in string.gmatch(output, "[^\n]+") do
        returnSignal = s
    end

    output = output:sub(0, -(len(returnSignal) + 3))

    return tonumber(returnSignal), output
end