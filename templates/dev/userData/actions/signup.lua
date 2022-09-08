local user, err, msg
local returnTable = {html = {}}

if request.password ~= request.password2 then
	returnTable.success = false
	returnTable.error = -111
	returnTable.reason = "Passwords are not matching"
	returnTable.html.forwardInternal = "signupError"
else
	user, err = env.dyn.User.create(request.username, request.password)
	if user ~= 0 then
		returnTable.success = false
		returnTable.reason = err
		returnTable.html.forwardInternal = "signupError"
	else
		returnTable.success = true
		returnTable.html.forward = "login"
	end
end

log(suc, reason)


return returnTable