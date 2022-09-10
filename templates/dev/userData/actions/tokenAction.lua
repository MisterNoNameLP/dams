local session, user = env.dyn.loginRequired(requestData)
if session == false then
    return user
end

local responseTable = {html = {}}
local body = env.dyn.html.Body.new()

if request.tokenAction == "delete" then
    local suc

    suc = env.loginDB:exec([[DELETE FROM sessions WHERE sessionID = "]] .. request.sessionID .. [["]])

    if suc ~= 0 then
        responseTable.html.body = "Something went wrong. Please contact an admin.\nError: " .. tostring(suc)
    else
        body:goTo(" ", 0)
    end
elseif request.tokenAction == "renew" then
    --body:goTo(" ", 0)
end

responseTable.html.body = body:generateCode()

return responseTable 