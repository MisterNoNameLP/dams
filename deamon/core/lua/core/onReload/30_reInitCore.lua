local _M, shared = ...

if _M._I.devConf.onReload.core then
	dlog("Re init core")

	_G.loadfile = _M._I.org.loadfile

	local _, newEnv, newShared = loadfile("core/lua/core/init.lua")(_M._I.damsVersion, _M._I.args)
	
	newEnv.oldEnv = env
	
	_M._I.dl.setEnv(newEnv, newShared)
end