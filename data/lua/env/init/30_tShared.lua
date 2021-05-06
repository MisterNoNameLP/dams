local env = ...

local shared = {
}
local _internal = {
	channelID = env.getThreadInfos().id,
}
setmetatable(shared, {_internal = _internal})

local requestChannel = env.thread.getChannel("SHARED_REQUEST")
local responseChannel = env.thread.getChannel("SHARED_RESPONSE#" .. tostring(_internal.channelID))

local ldlog = debug.lowLevelSharingLog 

--=== set meta tables ===--
debug.setFuncPrefix("[SHARED]")
dlog("Set metatables")

setmetatable(shared, {
	__index = function(_, index)
		ldlog("Get value: " .. tostring(index))
		requestChannel:push({
			request = "get",
			id = _internal.channelID,
			index = index,
		})
		
		return responseChannel:demand()
	end,
	__newindex = function(_, index, value)
		ldlog("Set value: " .. tostring(index))
		requestChannel:supply({
			request = "set",
			id = _internal.channelID,
			index = index,
			value = value,
		})
	end,
})


env.shared = shared
--_G.shared = shared