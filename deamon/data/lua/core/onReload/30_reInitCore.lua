local _M, shared = ...

if _M.devConf.onReload.core then
	dlog("Re init core")

	_G.loadfile = _M.org.loadfile

	local _, newEnv, newShared = loadfile("data/lua/core/init.lua")(_M.damsVersion, _M.args)
	
	newEnv.oldEnv = env
	
	_M.dl.setEnv(newEnv, newShared)
end