local session, err, msg = env.dyn.getSessionByRequestData(requestData)

if session == false then
    return {html = {body = "Logout failed: " .. err .. ": " .. msg}}
end

session:delete()

return {html = {forward = "/"}}