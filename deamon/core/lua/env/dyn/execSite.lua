--[[executes an api site
	returns: returnCode, responseBody / error, responseHeaders

	returnCodes:
		0 == successfully executet site
		1 == invalid request
		2 == invalid path given
		3 == requested site not found
		4 == failed to load requestet site
		5 == coult not execute requestet site
		6 == multiple sites with the same name existing
		7 == unsupported file type
		99 == unknown error
]]

return function(site, requestData)
	local sitePath = site
	local siteFunc
	local scriptFuncLoadingCode, scriptFunc, scriptFuncLoadingError
	local returnValue

	if site == "/" then
		sitePath = "_root"
	end
	sitePath = "api/sites/" .. sitePath --completing sitePath

	scriptFuncLoadingCode, scriptFunc, scriptFuncLoadingError = _I.getScriptFunc(sitePath)

	if scriptFuncLoadingCode == 0 then
		local scriptExecutionSuccess, returnBody, returnHeaders = xpcall(scriptFunc, debug.traceback, requestData)

		if scriptExecutionSuccess ~= true then
			debug.err("Site execution failed")
			debug.err(scriptExecutionSuccess, returnBody)
			return 5, [[
Site script crashed. Please contact a system administrator.
Stack traceback:
]] .. tostring(scriptFuncLoadingError)
		else
			return 0, returnBody, returnHeaders
		end
	elseif scriptFuncLoadingCode == 2 then
		return 3, "Site not found"
	elseif scriptFuncLoadingCode == 3 then
		return 4, "Could not load site script", scriptFunc
	elseif scriptFuncLoadingCode == 4 then
		return 6, "Multiple sites with that name existing"
	elseif scriptFuncLoadingCode == 5 then
		return 7, "Unsupported file type"
	end

	return 99
end