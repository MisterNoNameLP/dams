return function(user, expireDate, name, note, requestData)
	local session

	if type(user) ~= "table" then
		error("No valid user given", 2)
	end

	return _M.dyn.Session.create(user, expireDate, name, note, requestData)

	--[[
	local sessionID = _M.ut.randomString(32)
	local user
	
	while _M.getSession(sessionID) ~= nil do
		sessionID = _M.ut.randomString(32)
	end
	
	userData.loginToken = sessionID
	user = _M.User.new(userData)
	_M.shared.openSessions[sessionID] = user:getData()
	
	return sessionID
	]]
end