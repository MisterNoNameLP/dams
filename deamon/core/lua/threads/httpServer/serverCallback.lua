local httpHeaders = require "http.headers"

local openStreams = {}
local _
local damsVersion = _M._I.damsVersion

local function callback(myserver, stream)
	--=== create local variables ===--
	local callbackStream, callbackData
	
	local req_headers = assert(stream:get_headers())
	local requestData, headers = {}, {}
	local connectionIP, realIP = select(2, stream:peername()), nil

	--=== init ===--
	ldlog("Load headers")
	for index, value, neverIndex in req_headers:each() do
		headers[index] = {
			value = value, 
			neverIndex = neverIndex,
		}
	end

	ldlog("Get IP")
	if headers["proxy-ip"] ~= nil then
		realIP = headers["proxy-ip"].value
	else
		realIP = connectionIP
	end

	requestData.headers = headers
	requestData.body = stream:get_body_as_string()
	requestData.meta = {realIP = realIP, connectionIP = connectionIP}

	log("Got user request: connectionIP/realIP: " .. tostring(select(2, stream:peername()) .. "/" .. realIP))

	--===== start callback thread =====--
	ldlog("Start callback thread")
	local _, thr, id = _M._I.startFileThread("core/lua/threads/httpServer/callbackThread.lua", "HTTP_CALLBACK_THREAD", requestData)
	callbackStream = _M._I.thread.getChannel("HTTP_CALLBACK_STREAM#" .. tostring(id))

	--=== wait for callback thread to stop ===--
	ldlog("Wait for callback thread to stop")
	while thr:isRunning() do _M._I.cqueues.sleep(.1) end
	callbackData = callbackStream:pop()
	
	--=== build response headers ===--
	ldlog("Building headers")
	local respondHeaders = httpHeaders.new()
	if not callbackData.headers[":status"] then
		respondHeaders:append(":status", "200")
	end
	respondHeaders:append("dams-version", damsVersion)
	--respondHeaders:append("content-type", "lua table")
	for i, c in pairs(callbackData.headers) do
		if type(c) == "string" or type(c) == "number" then
			respondHeaders:append(i, tostring(c))
		end
	end
	if callbackData.cookies then
		for name, value in pairs(callbackData.cookies) do
			respondHeaders:append("set-cookie", tostring(name) .. "=" .. tostring(value))
		end
	end

	stream:write_headers(respondHeaders, false)
	
	--=== send data ===--
	ldlog("Sending data")
	--stream:write_chunk(_M._I.serialization.dump(callbackData.data)) --not needed anymore soon.
	stream:write_chunk(callbackData.data)
	stream:write_chunk("", true)
end

return function(myserver, stream)
	callback(myserver, stream)
end













