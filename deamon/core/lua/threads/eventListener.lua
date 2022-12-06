--[[
	default enevt DAMS is listening to.
]]

log("Starting event listener")

dlog("Register all listeners")

_M._I.event.listen("STOP_PROGRAM", function(data)
	log("Stopping program")
	_M._I.getInternal().stopThreads()
	require("love.event").quit("Stopped by event")
end)

dlog("Listeners registration done")

_I.keepAlive()