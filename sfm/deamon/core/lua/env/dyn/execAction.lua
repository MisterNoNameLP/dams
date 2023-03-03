--[[executes an api action
    returns: returnCode, responseData / error, responseHeaders

    returnCodes:
        0 == successfully executet action code
        1 == invalid request
        2 == invalid path given
        3 == requested action not found
        4 == failed to load requestet action
        5 == coult not execute requestet action
        6 == multiple actions with the same name existing
        99 == unknown error
]]

return function(request, requestData)
	local scriptFuncLoadingCode, scriptFunc
    local requestedAction
    local responseData = {}
    local responseHeaders

    assert(type(request) == "table", "bad argument #1 to 'execAction' (table expected, got " .. type(request) .. ")")

	requestData.request = request
	requestedAction = request.action
	
	if requestedAction ~= nil then
		scriptFuncLoadingCode, scriptFunc = _M._I.getScriptFunc("api/actions/" .. requestedAction)

        --dlog(scriptFuncLoadingCode, scriptFunc)
        --dlog(scriptFunc)

    else
		return 1, "Invalid request"
	end

	if scriptFuncLoadingCode == 0 then
		local logPrefix = _M._I.debug.getLogPrefix()
        local scriptExecutionSuccess, scriptReturnValue
		
        debug.setLogPrefix("[ACTION]")
		scriptExecutionSuccess, scriptReturnValue, responseHeaders = xpcall(scriptFunc, debug.traceback, requestData)
        if scriptExecutionSuccess then
		    responseData.success = true
            responseData.returnValue = scriptReturnValue
            return 0, responseData, responseHeaders
        else
            return 5, "Action script crashed", scriptReturnValue
        end
		if responseData.returnValue.error then --remove error table from response if not used
			local used = false
			for _ in pairs(responseData.returnValue.error) do
				used = true
				break
			end
			if not used then
				responseData.returnValue.error = nil
			end
		end
		debug.setLogPrefix(logPrefix)
    elseif scriptFuncLoadingCode == 1 then
        return 2, "Invalid path given"
    elseif scriptFuncLoadingCode == 2 then
        return 3, "Action not found", scriptFunc
    elseif scriptFuncLoadingCode == 3 then
        return 4, "Failed to load action", scriptFunc
    elseif scriptFuncLoadingCode == 4 then
        return 6, "Multiple actions with that name"
    else
        return 99, "Unknown error", scriptFunc
	end
end