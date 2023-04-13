local version, args = ...

--===== parse args/defConf =====--
local args = loadfile("core/lua/core/parseArgs.lua")(args, version) --parse args

--===== pre initialisation =====--

local devConf
do --loadl dev conf
	local suc, err = loadfile("core/devConf.lua")
	if not suc then
		error("Could not load devConf: " .. err)
	end
	devConf = suc()
end
local logfile = loadfile("core/lua/core/initLogfile.lua")(devConf, args)

local _M, shared = loadfile("core/lua/env/envInit.lua")({name = "[MAIN]", mainThread = true, id = 0, logfile = logfile, damsVersion = version})
local _I = _M._I

_I.debug.logfile = logfile
_I.args = args

--===== start initialisation =====--
log("Start initialization")
debug.setFuncPrefix("[INIT]")

dlog("Initialize main env")
local mainTable = loadfile("core/lua/core/mainTable.lua")() --TODO: still needed?
for i, c in pairs(mainTable) do
	_M._I[i] = c
end
_I.args = args

--=== load core files ===--
dlog("Initialize terminal")
loadfile(_I.devConf.terminalPath .. "terminalManager.lua")(_M)

loadfile("core/lua/core/shutdown.lua")(_M)

--=== load dynamic data ===--
log("Initialize core")
_I.dl.executeDir("core/lua/core/init", "INIT_SYSTEM")

log("Initialize api")
_I.dl.executeDir("api/init", "INIT_USER")

log("Initialization done")

return true, _M, shared