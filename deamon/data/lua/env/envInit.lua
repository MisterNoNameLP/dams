--pre initializes the _M for all threads

local initData = ...
local _M = {
	_I = {
		mainThread = initData.mainThread,
		initData = initData,
		damsVersion = initData.damsVersion,
	} --contains all internal variables.
	--threadName = initData.name,
}
local _internal = {
	threadID = initData.id,
	threadName = initData.name,
	threadIsActive = true,
}
setmetatable(_M, {_internal = _internal})
_G._M = _M --obsolet in v1.x
_G._E = _M

if initData.mainThread == true then --makes the print funciton logging into the logfile until the terminal is initialized. wich then replaces the global print function and takes take about the logging.
	local orgPrint = print

	_G.print = function(...) --will be overwritten by terminal.lua.
		local msgString = ""
		orgPrint(...)
	
		for _, s in pairs({...}) do
			msgString = msgString .. tostring(s) .. "  "
		end

		initData.logfile:write(msgString .. "\n")
		initData.logfile:flush()
	end
end

--=== load devConf ===--
local devConf = loadfile("data/devConf.lua")()
_M._I.devConf = devConf

package.path = devConf.requirePath .. ";" .. package.path
package.cpath = devConf.cRequirePath .. ";" .. package.cpath

--=== set debug ===--
_M._I.debug = loadfile("data/lua/env/debug.lua")(devConf, tostring(_internal.threadName) .. "[ENV_INIT]")

--=== disable _M init logs for non main threads ===--
if not _M._I.mainThread and not _M._I.devConf.debug.logLevel.threadEnvInit then
	debug.setSilenceMode(true)
end

--=== set environment ===--
dlog("Load coreEnv")
loadfile("data/lua/env/coreEnv.lua")(_M, _M._I.mainThread)

--NOTE: "data/" is default path from here on

dlog("Loading core libs")
_M._I.fs = require("love.filesystem")
_M._I.ut = require("UT")
_M._I.dl = loadfile("lua/libs/dataLoading.lua")(_M)

dlog("Initialize the environment")
debug.setLogPrefix(tostring(_internal.threadName))

_M._I.dl.executeDir("lua/env/init", "envInit")

dlog("Load dynamic data")
_M._I.dl.load({
	target = _M._I, 
	dir = "lua/env/dynData", 
	name = "dynData", 
	structured = true,
	execute = true,
})


_G._S = _M._I.shared
--[[ wut?
for i, c in pairs(_M._I._G) do
	_G[i] = c
end
]]

--_M._I.dl.loadDir("lua/env/dynData/test", {}, "dynData")

--=== enable logs again ===--
debug.setSilenceMode(false)

return _M, _M._I.shared