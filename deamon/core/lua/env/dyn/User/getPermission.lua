return function(self, perm)
<<<<<<<< HEAD:deamon/core/lua/env/dyn/User/getPerm.lua
========
	if type(perm) ~= "string" then
		error("No valid permimssion name given", 2)
	end

>>>>>>>> b29c425b93f20094192a84d87a50c60e69b33d9e:deamon/core/lua/env/dyn/User/getPermission.lua
	local userID = self:getID()
	local db = _M._I.userDB
	local reason, suc = nil, nil
	local permLevel
	
	debug.ulog("Get perm: userID: " .. tostring(userID) .. ", perm: " .. perm)
	suc = db:exec([[SELECT level FROM permissions WHERE userID = "]] .. tostring(userID) .. [[" AND permission = "]] .. perm .. [["]], function(udata, cols, values, names)
		permLevel = values[1]
		return 0
	end)
	
	if suc == 0 and permLevel ~= nil then
		return true, permLevel
	elseif suc == 0 and permLevel == nil then
		return false, permLevel
	else
		return suc, reason
	end
end