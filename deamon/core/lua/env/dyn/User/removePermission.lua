return function(self, perm, level)
	local userID = self:getID()
	local db = _M._I.userDB
	local reason, suc = nil, nil
	
<<<<<<<< HEAD:deamon/core/lua/env/dyn/User/delPerm.lua
	local permSetAlready, permLevelError = self:getPerm(perm)
========
	local permSetAlready, permLevelError = self:getPermission(perm)
>>>>>>>> b29c425b93f20094192a84d87a50c60e69b33d9e:deamon/core/lua/env/dyn/User/removePermission.lua
	
	debug.ulog("Delete permission: " .. perm .. ", userID: " .. tostring(userID))
	suc = db:exec([[DELETE FROM permissions WHERE permission = "]] .. perm .. [[" AND userID = ]] .. tostring(userID))
	
	return suc, reason
end