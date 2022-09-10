local user, err, msg = env.dyn.User.new(requestData.request.username)
local returnTable = {html = {}}

log("Logging in")

if user == false then
	returnTable.success = false
	returnTable.error = err
	returnTable.reason = msg
	returnTable.html.forwardInternal = "loginError"
elseif user:checkPasswd(requestData.request.password) then
	local suc, err, loginToken = env.newSession(user, -1, "Login", "Created during a login process.", requestData)
	
	--log(loginToken)

	if not suc then
		returnTable.success = false
		returnTable.error = err
		returnTable.reason = "Unknown error. Pleas contact an admin."
		returnTable.html.forwardInternal = "loginError"
	end

	cookie.new.token = loginToken
	returnTable.success = true
	returnTable.token = loginToken
	returnTable.html.forward = "dashboard"
else
	returnTable.success = false
	returnTable.reason = "Invalid password"
	returnTable.html.forwardInternal = "loginError"
end

log(suc, reason)


return returnTable