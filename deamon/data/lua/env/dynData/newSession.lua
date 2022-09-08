return function(user, expireDate)
	local session

	if type(user) ~= "table" then
		error("No valid user given", 2)
	end

	return env.dyn.Session.create(user, expireDate)

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