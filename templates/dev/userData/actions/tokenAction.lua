local session, user = env.dyn.loginRequired(requestData)
if session == false then
    return user
end

local responseTable = {html = {}}
local body = env.dyn.html.Body.new()

if request.tokenAction == "delete" then
    local suc
    local expireDate = os.date("*t")

    expireDate.day = expireDate.day + 7 --ToDo: add expire date setting.


    suc = env.loginDB:exec([[UPDATE sessions SET status = 1 WHERE sessionID = "]] .. request.sessionID .. [["]])
    suc = env.loginDB:exec([[UPDATE sessions SET deletionTime = ]] .. os.time(expireDate) .. [[ WHERE sessionID = "]] .. request.sessionID .. [["]])

    if suc ~= 0 then
        responseTable.html.body = "Something went wrong. Please contact an admin.\nError: " .. tostring(suc)
    else
        body:goTo(" ", 0)
    end
elseif request.tokenAction == "restore" then
    local suc

    suc = env.loginDB:exec([[UPDATE sessions SET status = 0 WHERE sessionID = "]] .. request.sessionID .. [["]])
    suc = env.loginDB:exec([[UPDATE sessions SET deletionTime = -1 WHERE sessionID = "]] .. request.sessionID .. [["]])

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