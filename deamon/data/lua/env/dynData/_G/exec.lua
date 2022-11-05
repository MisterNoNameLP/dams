local len = require("utf8").len
local posix = require("posix")

return function(cmd, envTable, secret, pollTimeout)
    local execString = ""
    local handlerFile, handlerFileDescriptor, events, output
    local discriptorList = {}
    local returnSignal
    
    if envTable then
        execString = execString .. env.dyn.sh.envSetup(envTable)
    end
    execString = execString .. " " .. cmd .. " 2>&1; printf \"\n$?\""

    if secret ~= true then
        debug.exec("Execute cmd: " .. execString)
    end
    handlerFile = io.popen(execString, "r")

    --make poopen file stream non blocking
    handlerFileDescriptor = posix.fileno(handlerFile)
    discriptorList[handlerFileDescriptor] = {events = {IN = true}}
    pollTimeout = math.floor((pollTimeout or .01) * 1000)
    while true do
        events = posix.poll(discriptorList, pollTimeout)
        if events > 0 and discriptorList[handlerFileDescriptor].revents.HUP then
            break
        end
    end

    --reading handler file
    output = handlerFile:read("*a")
    handlerFile:close()

    --getting exec exit code
    for s in string.gmatch(output, "[^\n]+") do
        returnSignal = s
    end

    output = output:sub(0, -(len(returnSignal) + 2))

    return tonumber(returnSignal), output
end