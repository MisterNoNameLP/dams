local _M, shared = ...

print("--===== RELOAD =====--")
debug.setFuncPrefix("[RELOAD]")

--loadfile("data/lua/core/init/test.lua")(_M, shared)

_M.dl.executeDir("lua/core/onReload", "RELOAD_CORE")
--_M.dl.executeDir("lua/env/onReload", "RELOAD_ENV") --would have to be done for all individual environments.
--_M.dl.executeDir("lua/onReload", "RELOAD_SYSTEM")
_M.dl.executeDir("userData/onReload", "RELOAD_USER")