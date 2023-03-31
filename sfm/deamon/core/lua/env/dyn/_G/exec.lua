local len = require("utf8").len
local posix = require("posix")

return function(cmd, envTable, secret, pollTimeout)
    local execString = ""
    local handlerFile, handlerFileDescriptor, events
    local discriptorList = {}
    local returnSignal
	 local tmpOutput, output = "", ""
    
    if envTable then
        execString = execString .. _M._I.sh.envSetup(envTable)
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
		  --reading handler file
		  tmpOutput = handlerFile:read("*a")
		  if tmpOutput then
		  	   output = output .. tmpOutput
		  end

        if events > 0 and discriptorList[handlerFileDescriptor].revents.HUP then
            break
        end
    end

    --reading rest of handler file
	 tmpOutput = handlerFile:read("*a")
	 if tmpOutput then
		output = output .. tmpOutput
	 end
	 handlerFile:close()

    --getting exec exit code
    for s in string.gmatch(output, "[^\n]+") do
        returnSignal = s
    end

    output = output:sub(0, -(len(returnSignal) + 2))

    return tonumber(returnSignal), output
end