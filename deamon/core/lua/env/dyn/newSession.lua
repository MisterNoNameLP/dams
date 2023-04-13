return function(user, expireDate, name, note, requestData)
	local session

	if type(user) ~= "table" then
		error("No valid user given", 2)
	end

	return _M._I.Session.create(user, expireDate, name, note, requestData)

	--[[
	local sessionID = _M._I.ut.randomString(32)
	local user
	
	while _M._I.getSession(sessionID) ~= nil do
		sessionID = _M._I.ut.randomString(32)
	end
	
	userData.loginToken = sessionID
	user = _M._I.User.new(userData)
	_M._I.shared._openSessions[sessionID] = user:getData()
	
	return sessionID
	]]
end