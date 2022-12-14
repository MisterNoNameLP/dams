--[[
	default enevt DAMS is listening to.
]]

log("Starting event listener")
log("Register all listeners")

_M._I.event.listen("STOP_PROGRAM", function(data)
	log("Stopping program")
	_M._I.getInternal().stopThreads()
	require("love.event").quit("Stopped by event")
end)

log("Listeners registration done")

_I.keepAlive()