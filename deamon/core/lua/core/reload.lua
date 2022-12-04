local _M, shared = ...

print("--===== RELOAD =====--")
debug.setFuncPrefix("[RELOAD]")

--loadfile("data/lua/core/init/test.lua")(_M, shared)

_M._I.dl.executeDir("core/lua/core/onReload", "RELOAD_CORE")
--_M._I.dl.executeDir("lua/env/onReload", "RELOAD_ENV") --would have to be done for all individual environments.
--_M._I.dl.executeDir("lua/onReload", "RELOAD_SYSTEM")
_M._I.dl.executeDir("api/onReload", "RELOAD_USER")