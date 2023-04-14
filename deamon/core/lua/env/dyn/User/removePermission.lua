return function(self, perm, level)
	local userID = self:getID()
	local db = _M._I.userDB
	local reason, suc = nil, nil
	
	local permSetAlready, permLevelError = self:getPermission(perm)
	
	debug.ulog("Delete permission: " .. perm .. ", userID: " .. tostring(userID))
	suc = db:exec([[DELETE FROM permissions WHERE permission = "]] .. perm .. [[" AND userID = ]] .. tostring(userID))
	
	return suc, reason
end