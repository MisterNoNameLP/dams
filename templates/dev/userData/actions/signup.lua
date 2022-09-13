local user, err, msg

response.error.headline = "Signup failed"

if request.password ~= request.password2 then
	response.success = false
	response.error.code = -111
	response.error.err = "Passwords are not matching"
	response.html.forwardInternal = "error"
else
	user, err = env.dyn.User.create(request.username, request.password)
	if user ~= 0 then
		response.success = false
		response.error.err = err
		response.error.code = user
		response.html.forwardInternal = "error"
	else
		response.success = true
		response.html.forward = "login"
	end
end

log(suc, reason)


return response