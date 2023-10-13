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
local function loadFormatter(acceptTable, path)
	ldlog("Load formatter in dir: " .. path)

	local formatter, suc, err

	--[[
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
	]]

	if acceptTable then
		local mostPreferredFormat
		local highestQFactor = 0

		for format, parameters in pairs(acceptTable) do
			if type(_I.lib.lfs.attributes(path .. "/" .. format:gsub("/", "_") .. ".lua")) == "table" then
				if _I.lib.ut.parseArgs(parameters.q, 1) > highestQFactor then
					mostPreferredFormat = format
					highestQFactor = _I.lib.ut.parseArgs(parameters.q, 1)
				end
			end
		end
		if not mostPreferredFormat then 
			canExecuteUserOrder = false
			return 1, "No supported response format accepted by client"
		end
		formatter, err = loadfile(path .. "/" .. mostPreferredFormat:gsub("/", "_") .. ".lua")
		if type(formatter) ~= "function" then 
			warn("Can't load formatter: " .. mostPreferredFormat .. ", error: " .. err)
			responseData.error = "Can't load formatter: " .. mostPreferredFormat
			responseData.scriptError = err
			canExecuteUserOrder = false
			return 2, err
		else
			return formatter, mostPreferredFormat
		end
	else
		canExecuteUserOrder = false
		return 3, "No accpeted format specified"
	end
end

local function executeAction()
	do --formatting user request
		local suc
		local logPrefix
		local requestFormat = "application/json"

		if requestData.headers["content-type"] then
			requestFormat = requestData.headers["content-type"].value
		end

		--[[
		if requestData.headers[":method"].value == "POST" then
			requestData.headers["request-format"] = {value = "HTML"}
			requestData.headers["response-format"] = {value = "HTML"}
		end
		]]

		--load request formatter
		requestFormatter, requestFormatterName = loadFormatter(_I.parseAcceptHeader(requestFormat), requestFormatterPath)
		if requestFormatter == 1 then
			responseData.errorCode = -1001
		elseif requestFormatter == 2 then
			responseData.errorCode = -1011
		elseif requestFormatter == 3 then
			responseData.errorCode = -1005
		end

		--load response formatter
		--responseFormatter, responseFormatterName = loadFormatter("response-format", responseFormatterPath)
		responseFormatter, responseFormatterName = loadFormatter(requestData.accept, responseFormatterPath)
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
			if #requestData.body > 0 then
				debug.setLogPrefix("[REQUEST_FORMATTER][" .. requestFormatterName .. "]")
				suc, userRequest = xpcall(requestFormatter, debug.traceback, requestData.body)
				debug.setLogPrefix(logPrefix)
			else
				suc, userRequest = true, {}
			end

			if suc ~= true then
				warn("Failed to execute request formatter: " .. requestFormatterName .. "; " .. tostring(userRequest))
				responseData.error = "Request formatter returned an error."
				responseData.scriptError = tostring(userRequest)
				canExecuteUserOrder = false
			end
		else
			if type(requestFormatter) ~= "function" then
				responseData.error = requestFormatterName
			elseif type(responseFormatter) ~= "function" then
				responseData.error = responseFormatterName
			else
				responseData.error = "Unknown error"
			end
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

		if type(newResponseHeaders) ~= "table" then
			newResponseHeaders = {}
		end
		for i, c in pairs(newResponseHeaders) do 
			responseHeaders[i] = c
		end
	end

	do --debugdebug.dump(responseHeaders)
		if type(shared._requestCount) ~= "number" then
			shared._requestCount = 0
		end
		shared._requestCount = shared._requestCount +1
		responseData.requestID = tostring(shared._requestCount)
	end

	do --formatting response table
		--responseData = _M._I.lib.serialization.dump(responseData) --placeholder
		local suc, responseString = false, "[Formatter returned no error value]"

		if not responseHeaders["content-type"] then
			responseHeaders["content-type"] = {}
		end

		if type(responseFormatter) == "function" then
			suc, responseString = xpcall(responseFormatter, debug.traceback, responseData, requestData.headers, requestData)
		end

		if suc ~= true then
			local newResponseString = [[
Can't format response table. 
Formatter error: ]] .. tostring(responseString) .. [[ 
Falling back to human readable lua-table.
			]] .. "\n"

			responseHeaders["content-type"].value = "text/plain"

			newResponseString = newResponseString .. _M._I.lib.ut.tostring(responseData)
			responseBody = newResponseString
		else
			responseBody = responseString
			if not responseHeaders["content-type"].value then
				responseHeaders["content-type"].value = responseFormatterName
			end
		end
	end
end

local function executeSite()
	local logPrefix = _M._I.debug.getLogPrefix()
	local requestedSite = requestData.headers[":path"].value
	local siteExecutionCode, siteExecutionResponse, newResponseHeaders

	debug.setLogPrefix("[SITE]")

	siteExecutionCode, siteExecutionResponse, newResponseHeaders = _I.execSite(requestedSite, requestData)

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
		debug.err("Failed to load requested site: " .. tostring(requestedSite) .. ", " .. tostring(siteExecutionResponse) .. "; " .. tostring(newResponseHeaders))
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

	if type(newResponseHeaders) ~= "table" then
		newResponseHeaders = {}
	end
	for i, c in pairs(newResponseHeaders) do 
		responseHeaders[i] = c
	end
	if not responseHeaders["content-type"] then
		responseHeaders["content-type"] = {}
	end
	if not responseHeaders["content-type"].value then
		responseHeaders["content-type"].value = "text/html;charset=UTF-8"
	end

	debug.setLogPrefix(logPrefix)
end

--===== processing user request =====--
--[[if a site is executed the response body will be build as a string direclty by the site script.
	on the other hand, if an action is executet the responseData table is used to manage the response of scripts and the framework itself.
	the responseData table is then converteted into a responseBody string using the given response formatter.
]]
local function processUserRequest() --called imediately but sandboxed.
	_M._I.cookie.current = _M._I.getCookies(requestData)
	if requestData.headers.accept then
		requestData.accept = _I.parseAcceptHeader(requestData.headers.accept.value)
	end
	if 
		(not _I.devConf.http.apiSubdomain or requestData.headers[":authority"].value:find(_I.devConf.http.apiSubdomain:gsub("%.", "%%%.")) == 1) and 
		(not _I.devConf.http.apiPath or requestData.headers[":path"].value:find(_I.devConf.http.apiPath:gsub("%.", "%%%.")) == 2)
	then
		if _I.devConf.http.apiPath then
			requestData.headers["real-path"] = {value = requestData.headers[":path"].value}
			requestData.headers[":path"].value = requestData.headers[":path"].value:sub(#_I.devConf.http.apiPath + 1)
		end
		executeAction()
	else
		executeSite()
	end
end
do 
	local suc, error
	suc, error = xpcall(processUserRequest, debug.traceback)
	if not suc then
		err("Unknown crash:\n" .. tostring(error))
		responseBody = "HTTP server callback thread crashed! Please contact an admin.\nERROR: " .. tostring(error)
		responseData.error = "HTTP server callback thread crashed\n ERROR:" .. tostring(error)
	end
end


--===== finishing up =====--
callbackStream:push({headers = responseHeaders, data = responseBody, cookies = _M._I.cookie.new})
_M._I.cookie = {current = {}, new = {}}
ldlog("CALLBACK THREAD END")
_M._I.stop()