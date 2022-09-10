local returnTable = {html = {}}
local user, err, msg
local session, user = env.dyn.loginRequired(requestData)

if session == false then
    return {html = {body = user}}
end

if user:checkPasswd(request.currentPassword) then
    if request.newPassword ~= request.newPassword2 or request.newPassword == "" or request.newPassword == nil then
        returnTable.success = false
        returnTable.error = -111
        returnTable.reason = "Password are not mathing"
        returnTable.html.forwardInternal = "changePasswordError"
    else
        err, msg = user:setPasswd(request.newPassword)

        if err == 0 then
            returnTable.success = true
            returnTable.html.forward = "dashboard"
        else
            returnTable.success = false
            returnTable.error = err
            returnTable.reason = msg
            returnTable.html.forwardInternal = "changePasswordError"
        end
    end
else
    returnTable.success = false
	returnTable.error = -3
	returnTable.reason = "Wrong password"
	returnTable.html.forwardInternal = "changePasswordError"
end


return returnTable