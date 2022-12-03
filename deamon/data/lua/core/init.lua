local version, args = ...

--===== parse args/defConf =====--
local args = loadfile("data/lua/core/parseArgs.lua")(args, version) --parse args

--===== pre initialisation =====--

local devConf = loadfile("data/devConf.lua")()
local logfile = loadfile("data/lua/core/initLogfile.lua")(devConf, args)

local _M, shared = loadfile("data/lua/env/envInit.lua")({name = "[MAIN]", mainThread = true, id = 0, logfile = logfile, damsVersion = version})

--NOTE: "data/" is now default path for loadfile.

_M.debug.logfile = logfile
_M.args = args

--===== start initialisation =====--
log("Start initialization")
debug.setFuncPrefix("[INIT]")

dlog("Initialize main env")
local mainTable = loadfile("lua/core/mainTable.lua")()
for i, c in pairs(mainTable) do
	_M[i] = c
end
_M.args = args

--=== run dyn init ===--
log("Initialize core level")
_M.dl.executeDir("lua/core/init", "INIT")

--=== load core files ===--
dlog("Initialize terminal")
loadfile(_M.devConf.terminalPath .. "terminalManager.lua")(_M)

loadfile("lua/core/shutdown.lua")(_M)

--=== load dynamic data ===--
_M.dl.load({
	target = _M.commands, 
	dir = "userData/commands", 
	name = "commands",
})

log("Initialize system level")
_M.dl.executeDir("lua/init", "INIT_SYSTEM")

log("Initialize user level")
_M.dl.executeDir("userData/init", "INIT_USER")

log("Initialization done")

return true, _M, shared