return function(self, passwd)
	local userID = self:getID()
	local db = _M._I.userDB
	local reason, suc = nil, nil
	local execString = ""
	
	debug.ulog("Set passwd: userID: " .. tostring(userID))

	--log(type(_M._I.hashPasswd(passwd)))

	suc = db:exec([[UPDATE users SET password = "]] .. _M._I.hashPasswd(passwd) .. [[" WHERE id = ]] .. tostring(userID))
	
	return suc, reason
end