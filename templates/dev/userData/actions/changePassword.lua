local user, err, msg
local session, user = env.dyn.loginRequired(requestData)

if session == false then
    return {html = {body = user}}
end

response.error.headline = "Changing password failed"

if user:checkPasswd(request.currentPassword) then
    if request.newPassword ~= request.newPassword2 or request.newPassword == "" or request.newPassword == nil then
        response.success = false
        response.error.code = -111
        response.error.err = "Password are not mathing"
        response.html.forwardInternal = "error"
    else
        err, msg = user:setPasswd(request.newPassword)

        if err == 0 then
            response.success = true
            response.html.forward = "dashboard"
        else
            response.success = false
            response.error.code = err
            response.error.err = msg
            response.html.forwardInternal = "error"
        end
    end
else
    response.success = false
	response.error.code = -3
	response.error.err = "Wrong password"
	response.html.forwardInternal = "error"
end


return response