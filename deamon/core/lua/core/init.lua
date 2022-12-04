local version, args = ...

--===== parse args/defConf =====--
local args = loadfile("core/lua/core/parseArgs.lua")(args, version) --parse args

--===== pre initialisation =====--

local devConf = loadfile("core/devConf.lua")()
local logfile = loadfile("core/lua/core/initLogfile.lua")(devConf, args)

local _M, shared = loadfile("core/lua/env/envInit.lua")({name = "[MAIN]", mainThread = true, id = 0, logfile = logfile, damsVersion = version})

_M._I.debug.logfile = logfile
_M._I.args = args

--===== start initialisation =====--
log("Start initialization")
debug.setFuncPrefix("[INIT]")

dlog("Initialize main env")
local mainTable = loadfile("core/lua/core/mainTable.lua")()
for i, c in pairs(mainTable) do
	_M[i] = c
end
_M._I.args = args

--=== load core files ===--
dlog("Initialize terminal")
loadfile(_M._I.devConf.terminalPath .. "terminalManager.lua")(_M)

loadfile("core/lua/core/shutdown.lua")(_M)

--=== load dynamic data ===--
_M._I.dl.load({
	target = _M._I.commands, 
	dir = "api/commands", 
	name = "commands",
})

log("Initialize core")
_M._I.dl.executeDir("core/lua/core/init", "INIT_SYSTEM")

log("Initialize api")
_M._I.dl.executeDir("api/init", "INIT_USER")

log("Initialization done")

return true, _M, shared