local user, err, msg = env.dyn.User.new(requestData.request.username)

log("Logging in")

response.error.headline = "Loggin in failed"

if user == false then
	response.success = false
	response.error.code = err
	response.error.err = msg
	response.html.forwardInternal = "error"
elseif user:checkPasswd(requestData.request.password) then
	local suc, err, loginToken = env.newSession(user, -1, "Login", "Created during a login process.", requestData)
	
	--log(loginToken)

	if not suc then
		response.success = false
		response.error.err = err
		response.error.msg = "Unknown error. Pleas contact an admin."
		response.html.forwardInternal = "error"
	end

	cookie.new.token = loginToken
	response.success = true
	response.token = loginToken
	response.html.forward = "dashboard"
else
	response.success = false
	response.error.err = "Invalid password"
	response.html.forwardInternal = "error"
end

log(suc, reason)


return response