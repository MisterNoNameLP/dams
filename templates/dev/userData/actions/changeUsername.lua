local returnTable = {html = {}}
local user, err, msg
local session, user = env.dyn.loginRequired(requestData)

if session == false then
    return {html = {body = user}}
end

if user:checkPasswd(request.password) then
	err, msg = user:setName(request.username)

    if err == 0 then
        returnTable.success = true
		returnTable.html.forward = "dashboard"
    else
        returnTable.success = false
        returnTable.error = err
        returnTable.reason = msg
        returnTable.html.forwardInternal = "changeUsernameError"
    end
else
    returnTable.success = false
	returnTable.error = -3
	returnTable.reason = "Wrong password"
	returnTable.html.forwardInternal = "changeUsernameError"
end


return returnTable