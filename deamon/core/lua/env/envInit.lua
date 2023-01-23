--pre initializes the _M for all threads

local initData = ...
local _M = {
	_I = {
		mainThread = initData.mainThread,
		initData = initData,
		damsVersion = initData.damsVersion,
	}, --contains all internal variables.
	_E = {}, --the env for the API functions.
}
local _internal = {
	threadID = initData.id,
	threadName = initData.name,
	threadIsActive = false,
}
setmetatable(_M, {_internal = _internal})
_G._M = _M
_G._I = _M._I

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
local devConf
do --loadl dev conf
	local suc, err = loadfile("core/devConf.lua")
	if not suc then
		error("Could not load devConf: " .. err)
	end
	devConf = suc()
end
_I.devConf = devConf

package.path = devConf.requirePath .. ";" .. package.path
package.cpath = devConf.cRequirePath .. ";" .. package.cpath

--=== set debug ===--
_I.debug = loadfile("core/lua/env/debug.lua")(devConf, tostring(_internal.threadName) .. "[ENV_INIT]", _M)

--=== disable _M init logs for non main threads ===--
if not _I.mainThread and not _I.devConf.debug.logLevel.threadEnvInit then
	debug.setSilenceMode(true)
end

--=== set environment ===--
dlog("Load coreEnv")
loadfile("core/lua/env/coreEnv.lua")(_M, _I.mainThread)


dlog("Loading core libs")
_I.fs = require("lfs")
_I.ut = require("UT")
_I.dl = loadfile("core/lua/libs/dataLoading.lua")(_M)

dlog("Initialize the environment")

debug.setLogPrefix(tostring(_internal.threadName))

dlog("Execute core env init")
debug.setFuncPrefix("[CORE_ENV_INI]")
_I.dl.executeDir("core/lua/env/init", "coreEnvInit")

dlog("Execute API env init")
debug.setFuncPrefix("[API_ENV_INI]")
_I.dl.executeDir("api/env/init", "apiEnvInit")

debug.setFuncPrefix("[CORE_ENV_DYN]")
dlog("Load dynamic core data")
_I.dl.load({
	target = _I, 
	dir = "core/lua/env/dyn", 
	name = "coreDyn", 
	structured = true,
	execute = true,
})

debug.setFuncPrefix("[API_ENV_DYN]")
dlog("Load dynamic API data")
_I.dl.load({
	target = _M._E, 
	dir = "api/env/dyn", 
	name = "apiDyn", 
	structured = true,
	execute = true,
})

debug.setFuncPrefix("[API_COMMANDS]")
dlog("Load commands")
_I.commands = {}
_I.dl.load({
	target = _I.commands, 
	dir = "api/commands", 
	name = "commands",
})

debug.setFuncPrefix("")

_G._S = _I.shared
for i, c in pairs(_I._G) do
	_G[i] = c
end

--_I.dl.loadDir("lua/env/dynData/test", {}, "dynData")

--=== enable logs again ===--
debug.setSilenceMode(false)

return _M, _I.shared