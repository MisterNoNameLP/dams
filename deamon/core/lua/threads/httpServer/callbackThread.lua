ldlog("CALLBACK THREAD START")

--===== local variables =====--
local callbackStream = _M._I.thread.getChannel("HTTP_CALLBACK_STREAM#" .. tostring(_M._I.getThreadInfos().id))

local responseHeaders = {}
--a response data table used by actions scripts and the frameworks itself to handle the response if an action is called.
local responseData = {success = false}
--the response body sended back to the client after a request is done processing.
local responseBody = "If you see this, something went terrebly wrong. Please contact a system administrator."

local requestData = _M._I.initData.args

local requestFormatter, responseFormatter
local requestFormatterName, responseFormatterName
local requestFormatterPath, responseFormatterPath = "./api/formatters/request/", "./api/formatters/response/"

local canExecuteUserOrder = true
local userRequest


--===== local functions =====--
local function loadFormatter(headerName, path)
	ldlog("Load " .. headerName .. " formatter, dir: " .. path)

	local formatter, suc, err

	if requestData.headers[headerName] ~= nil then
		local requestedFormatter = requestData.headers[headerName].value
		local pathString = path .. "/" .. requestedFormatter .. ".lua"
		local loveFSCompatiblePathString = string.sub(pathString, 3)--yes it is actually necessary to remove the './' infromt of the path...

		formatter, err = loadfile(pathString)

		if type(formatter) ~= "function" then
			if _M._I.lib.fs.getInfo(loveFSCompatiblePathString) == nil then --only generates a easyer to understand error msg if the formatter is not existing.
				responseData.error = "Requestet " .. headerName .. " not found (" .. requestedFormatter .. ")"
				responseData.scriptError = err
				canExecuteUserOrder = false
				return 1, headerName .. " not found"
			end

			warn("Can't load requestet " .. headerName .. ": ".. requestedFormatter .. ", error: " .. err)
			responseData.error = "Can't load requestet " .. headerName .. " (" .. requestedFormatter .. ")"
			responseData.scriptError = err
			canExecuteUserOrder = false
			return 2, err
		else
			return formatter, requestedFormatter
		end
	else
		canExecuteUserOrder = false
		return 3, "No formatter specified"
	end
end


--===== processing user request =====--
--[[if a site is executed the response body will be build as a string direclty by the site script.
	on the other hand, if an action is executet the responseData table is used to manage the response of scripts and the framework itself.
	the responseData table is then converteted into a responseBody string using the given response formatter.
]]
_M._I.cookie.current = _M._I.getCookies(requestData)
if requestData.headers[":method"].value == "GET" then --=== exec site ===--


	local logPrefix = _M._I.debug.getLogPrefix()
	local requestedSite = requestData.headers[":path"].value
	local siteExecutionCode, siteExecutionResponse, responseHeaders

	debug.setLogPrefix("[SITE]")

	siteExecutionCode, siteExecutionResponse, responseHeaders = _I.execSite(requestedSite, requestData)

	if siteExecutionCode == 0 then
		responseBody = siteExecutionResponse
	elseif siteExecutionCode == 1 then
		debug.crucial("Tryed to execute an invalid site request: " .. tostring(requestedSite))
		responseBody = "Tryed to execute an invalid site request: " .. tostring(requestedSite)
	elseif siteExecutionCode == 2 then
		warn("Recieved invalid site request: " .. tostring(requestedSite))
		responseBody = "Invalid site request: '" .. tostring(requestedSite) .. "'"
	elseif siteExecutionCode == 3 or siteExecutionCode == 7 then
		warn("Requested site not found: " .. tostring(requestedSite))
		responseBody = "Error 404: Site not found: '" .. tostring(requestedSite) .. "'"
	elseif siteExecutionCode == 4 then
		debug.err("Failed to load requested site: " .. tostring(requestedSite) .. ", " .. tostring(siteExecutionResponse) .. "; " .. tostring(responseHeaders))
		responseBody = "Failed to load Site: '"  .. tostring(requestedSite) .. "'"
	elseif siteExecutionCode == 5 then
		debug.err("Failed to execute requested site: " .. tostring(requestedSite))
		responseBody = "Failed to execute site: '" .. tostring(requestedSite) .. "'"
	elseif siteExecutionCode == 6 then
		debug.err("Multilpe sites with that name are existing: " .. tostring(requestedSite))
		responseBody = "Multilpe sites with that name are existing: " .. tostring(requestedSite)
	else
		debug.crucial("Unknown error while executing site: " .. tostring(requestedSite))
		responseBody = "Unknown error while executing site: '" .. tostring(requestedSite) .. "'"
	end

	if type(responseHeaders) ~= "table" then
		responseHeaders = {}
	end

	debug.setLogPrefix(logPrefix)
else --=== exec action ===--
	do --formatting user request
		local suc
		local logPrefix

		if requestData.headers[":method"].value == "POST" then
			requestData.headers["request-format"] = {value = "HTML"}
			requestData.headers["response-format"] = {value = "HTML"}
		end

		--load request formatter
		requestFormatter, requestFormatterName, errorCode = loadFormatter("request-format", requestFormatterPath)
		if requestFormatter == 1 then
			responseData.errorCode = -1001
		elseif requestFormatter == 2 then
			responseData.errorCode = -1011
		elseif requestFormatter == 3 then
			responseData.errorCode = -1005
		end

		--load response formatter
		responseFormatter, responseFormatterName = loadFormatter("response-format", responseFormatterPath)
		if responseFormatter == 1 then
			responseData.errorCode = -1002
		elseif responseFormatter == 2 then
			responseData.errorCode = -1012
		elseif responseFormatter == 3 then
			responseData.errorCode = -1006
		end

		--format user request using loaded requst formatter
		if canExecuteUserOrder then
			logPrefix = debug.getLogPrefix()
			debug.setLogPrefix("[REQUEST_FORMATTER][" .. requestFormatterName .. "]")
			suc, userRequest = xpcall(requestFormatter, debug.traceback, requestData.body)
			debug.setLogPrefix(logPrefix)

			if suc ~= true then
				warn("Failed to execute request formatter: " .. requestFormatterName .. "; " .. tostring(userRequest))
				responseData.error = "Request formatter returned an error."
				responseData.scriptError = tostring(userRequest)
				canExecuteUserOrder = false
			end
		else
			responseData.error = requestFormatterName
		end
	end

	--execute user order
	if canExecuteUserOrder then 
		--in case of error: errorCode, genericErrorMsg, specificErrorMsg. 
		local actionExecutionCode, newResponseData, newResponseHeaders = _I.execAction(userRequest, requestData)

		if actionExecutionCode == 0 then
			for i, c in pairs(newResponseData) do
				if responseData[i] then
					warn("responseData is overwritten: " .. tostring(i))
				end
				responseData[i] = c
			end
		elseif actionExecutionCode == 1 then
			debug.crucial("Tryed to execute an invalid action request")
		elseif actionExecutionCode == 2 then
			warn("Recieved invalid action request: " .. tostring(userRequest.action))
			responseData.error = "Invalid action request: " .. tostring(userRequest.action)
		elseif actionExecutionCode == 3 then
			warn("Requested action not found: " .. tostring(userRequest.action))
			responseData.error = "Requestes action not found: " .. tostring(userRequest.action)
		elseif actionExecutionCode == 4 then
			debug.err("Failed to load requested action: " .. tostring(userRequest.action) .. "; error:\n" .. tostring(newResponseHeaders))
			responseData.error = "Failed to load action request: " .. tostring(userRequest.action) .. "; error:\n" .. tostring(newResponseHeaders)
		elseif actionExecutionCode == 5 then
			debug.err("Failed to execute requested action: " .. tostring(userRequest.action) .. "; error:\n" .. tostring(newResponseHeaders))
			responseData.error = "Failed to execute action request: " .. tostring(userRequest.action) .. "; error:\n" .. tostring(newResponseHeaders)
		elseif actionExecutionCode == 6 then
			debug.err("Multilpe actions with that name are existing: " .. tostring(requestedSite))
			responseData.error = "Multilpe action with that name are existing: " .. tostring(userRequest.action)
		else
			debug.crucial("Unknown error while executing action: " .. tostring(userRequest.action) .. "; error: " .. tostring(newResponseData))
		end

		if type(responseHeaders) ~= "table" then
			responseHeaders = {}
		end
	end

	do --debug
		if type(shared._requestCount) ~= "number" then
			shared._requestCount = 0
		end
		shared._requestCount = shared._requestCount +1
		responseData.requestID = tostring(shared._requestCount)
	end

	do --formatting response table
		--responseData = _M._I.lib.serialization.dump(responseData) --placeholder
		local suc, responseString = false, "[Formatter returned no error value]"

		if type(responseFormatter) == "function" then
			suc, responseString = xpcall(responseFormatter, debug.traceback, responseData, requestData.headers, requestData)
		end

		if suc ~= true then
			local newResponseString = [[
Can't format response table. 
Formatter error: ]] .. tostring(responseString) .. [[ 
Falling back to human readable lua-table.
			]] .. "\n"

			responseHeaders["content-type"] = "text/html"

			newResponseString = newResponseString .. _M._I.lib.ut.tostring(responseData)
			responseBody = newResponseString
		else
			responseBody = responseString
			responseHeaders["content-type"] = responseFormatterName
		end
	end
end

--===== finishing up =====--
callbackStream:push({headers = responseHeaders, data = responseBody, cookies = _M._I.cookie.new})
_M._I.cookie = {current = {}, new = {}}
ldlog("CALLBACK THREAD END")
_M._I.stop()