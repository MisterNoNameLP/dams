return function(request, requestData)
	local func, err, requestedAction
    local responseData = {}
    local responseHeaders

	if type(request) ~= "table" then
		warn("Recieved invalid request: " .. tostring(request))
		responseData.error = "Invalid request format."
		return false
	else
		requestData.request = request
		requestedAction = request.action
	end
	
	if requestedAction ~= nil then
		func, err = _M._I.getActionFunc("api/actions/" .. requestedAction)
	end
	
	if type(func) == "function" then
		local logPrefix = _M._I.debug.getLogPrefix()
		debug.setLogPrefix("[ACTION]")
		responseData.returnValue, responseHeaders = func(requestData)
		responseData.success = true

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
	elseif func == nil then
		debug.err("Failed to load requested user action: " .. tostring(requestedAction) .. "; error:\n" .. tostring(err))
		responseData.error = "Failed to load requested action: " .. tostring(err)
	else
		warn("Recieved unknown user action request: " .. tostring(requestedAction))
		responseData.error = "Invalid user action: " .. tostring(err)
	end

    return responseData, responseHeaders
end