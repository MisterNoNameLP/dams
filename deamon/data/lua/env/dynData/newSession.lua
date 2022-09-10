return function(user, expireDate, name, note, requestData)
	local session

	if type(user) ~= "table" then
		error("No valid user given", 2)
	end

	return env.dyn.Session.create(user, expireDate, name, note, requestData)

	--[[
	local sessionID = env.ut.randomString(32)
	local user
	
	while env.getSession(sessionID) ~= nil do
		sessionID = env.ut.randomString(32)
	end
	
	userData.loginToken = sessionID
	user = env.User.new(userData)
	env.shared.openSessions[sessionID] = user:getData()
	
	return sessionID
	]]
end