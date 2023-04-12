local _M = ...

local shared = {
}
local _internal = {
	channelID = _M._I.getThreadInfos().id,
}
--setmetatable(shared, {_internal = _internal})

local requestChannel = _M._I.thread.getChannel("SHARED_REQUEST")
local responseChannel = _M._I.thread.getChannel("SHARED_RESPONSE#" .. tostring(_internal.channelID))
local requestIDChannel = _M._I.thread.getChannel("SHARED_CURRENT_REQUEST_ID")

local ldlog = debug.sharingDebug

function _internal.getRequestID()
	local requestID = requestIDChannel:demand()
	requestIDChannel:push(requestID +1)
	return requestID
end

function _internal.generateIndexString(indexTable)
	local indexString = ""
	for _, index in ipairs(indexTable) do
		--indexString = indexString .. tostring(index) .. "."
		indexString = _I.appendIndex(indexString, index)
		dlog(indexString)
	end
	--indexString = string.sub(indexString, 1, -2) --remove dot at the end
	--[[ --needed?
	if string.sub(indexString, 0, 1) == "." then --remove dot at the beginning if present
		indexString = string.sub(indexString, 2)
	end
	]]
	return indexString
end

function _internal.index(sharedTable, index, internalRun)
	local returnValue	
	local metatable = getmetatable(sharedTable)
	local newIndexTable = {}
	local requestID = _internal.getRequestID()


	--if an index ciontains a dot (.) it is put into single quotes to avoid missbehaviour with the lock table.
	if index:find("[.]") then
		warn("There are dots (.) used in shared table index '" .. index .. "'. This can cause missbehaviour!")
		index = "'" .. index .. "'"
	end

	if _M._I.devConf.debug.logLevel.sharingDebug then  --double check to prevent string concatenating process if debug output is disabled.
		ldlog("Get value: '" .. _internal.generateIndexString(getmetatable(sharedTable).indexTable or {}) .. "." .. tostring(index) .. "'; requestID: " .. tostring(requestID))
	end

	if metatable.indexTable ~= nil then
		for _, i in ipairs(metatable.indexTable) do
			table.insert(newIndexTable, i)
		end
		table.insert(newIndexTable, index)
	else
		newIndexTable = {index}
	end
	
	local function getValue()
		requestChannel:push({
			request = "get",
			threadID = _internal.channelID,
			requestID = requestID,
			indexTable = newIndexTable,
		})
		return responseChannel:demand()
	end

	returnValue = getValue()

	if type(returnValue) == "table" then
		local tostringValue = "shared_table: " .. string.sub(returnValue.address, 8)

		returnValue = setmetatable({}, {
			indexTable = newIndexTable,
			__index = _internal.index,
			__newindex = _internal.newindex,
			__tostring = function(self, a1, a2) --BUG: does return the wrong value if the shared table was changed. unfixable?
				return tostringValue
			end,
			__call = _internal.call,
		})
	end

	return returnValue
end

function _internal.newindex(sharedTable, index, value)
	metatable = getmetatable(sharedTable)
	local requestID = _internal.getRequestID()

	--if an index ciontains a dot (.) it is put into single quotes to avoid missbehaviour with the lock table.
	if index:find("[.]") then
		warn("There are dots (.) used in shared table index '" .. index .. "'. This can cause missbehaviour!")
		index = "'" .. index .. "'"
	end

	if _M._I.devConf.debug.logLevel.sharingDebug then  --double check to prevent string concatenating process if debug output is disabled.
		ldlog("Set value: '" .. _internal.generateIndexString(getmetatable(sharedTable).indexTable or {}) .. "." .. tostring(index) .. "'; new value: " .. tostring(value) .. "; requestID: " .. tostring(requestID))
	end

	--[[
	if string.find(index, "[.]") ~= nil then
		warn("A dot (.) is used in an shared table index. This can cause unexpectet behavour with locked tables!")
	end
	]]
	--index = index:gsub("[.]", "'.'")

	requestChannel:supply({
		request = "set",
		threadID = _internal.channelID,
		requestID = requestID,
		indexTable = metatable.indexTable or {},
		index = index,
		value = value,
	})

	responseChannel:demand() --wait till new value is actually written.
end

function _internal.call(sharedTable, ...)
	local args = {...}
	local order = args[1]
	local response, returnValue
	local bypassLock
	local requestID = _internal.getRequestID()

	ldlog("Send call request: " .. order .. "; requestID: " .. tostring(requestID))

	if order == "forceUnlock" then
		order = "unlock"
		bypassLock = true
	end

	requestChannel:push({
		request = "call",
		threadID = _internal.channelID,
		requestID = requestID,
		indexTable = getmetatable(sharedTable).indexTable,
		order = order,
		bypassLock = _M._I.ut.parseArgs(bypassLock, _internal.bypassLock),
	})

	response = responseChannel:demand()
	if response.value ~= nil then
		returnValue = response.value
	else
		if response.success then
			returnValue = true
		else
			returnValue = false
		end
	end
	return returnValue, response.error
end

--=== set meta tables ===--
debug.setFuncPrefix("[SHARED]")
dlog("Set metatables")

setmetatable(shared, {
	_internal = _internal,
	__index = _internal.index,
	__newindex = _internal.newindex,
	__tostring = function()
		return "sharing_table"
	end,
	__call = _internal.call,
})


_M._I.shared = shared
_M._S = shared
--_G.shared = shared