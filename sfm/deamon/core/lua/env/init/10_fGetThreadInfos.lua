_M._I.getThreadInfos = function()
	local _internal = getmetatable(_M)._internal
	
	return {
		id = _internal.threadID,
		name = _internal.threadName,
	}
end