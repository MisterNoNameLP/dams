local session, err, msg = _I.getSessionByRequestData(requestData)

if session == false then
    return {html = {body = "Logout failed: " .. err .. ": " .. msg}}
end

session:delete()

return {html = {forward = "/"}}