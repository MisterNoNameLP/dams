local user, err, msg
local session, user = env.dyn.loginRequired(requestData)

if session == false then
    return {html = {body = user}}
end

response.error.headline = "Chaging username failed"

if user:checkPasswd(request.password) then
	err, msg = user:setName(request.username)

    if err == 0 then
        response.success = true
		response.html.forward = "dashboard"
    else
        response.success = false
        response.error.code = err
        response.error.err = msg
        response.html.forwardInternal = "error"
    end
else
    response.success = false
	response.error.code = -3
	response.error.err = "Wrong password"
	response.html.forwardInternal = "error"
end


return response