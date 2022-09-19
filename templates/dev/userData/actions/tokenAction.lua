local session, user = env.dyn.loginRequired(requestData)
if session == false then
    return user
end

local body = env.dyn.html.Body.new()

if request.tokenAction == "disable" then
    local suc
    local expireDate = os.date("*t")

    expireDate.day = expireDate.day + 7 --ToDo: add expire date setting.
    
    suc = env.loginDB:exec([[UPDATE sessions SET status = 1 WHERE sessionID = "]] .. request.tokenID .. [["]])
    suc = env.loginDB:exec([[UPDATE sessions SET deletionTime = ]] .. os.time(expireDate) .. [[ WHERE sessionID = "]] .. request.tokenID .. [["]])
    if suc ~= 0 then
        response.html.body = "Something went wrong. Please contact an admin.\nError: " .. tostring(suc)
    else
        body:goTo(" ", 0)
    end
elseif request.tokenAction == "restore" then
    local suc
    suc = env.loginDB:exec([[UPDATE sessions SET status = 0 WHERE sessionID = "]] .. request.tokenID .. [["]])
    suc = env.loginDB:exec([[UPDATE sessions SET deletionTime = -1 WHERE sessionID = "]] .. request.tokenID .. [["]])
    if suc ~= 0 then
        response.html.body = "Something went wrong. Please contact an admin.\nError: " .. tostring(suc)
    else
        body:goTo(" ", 0)
    end
elseif request.tokenAction == "delete" then
    local suc

    suc = env.loginDB:exec([[DELETE FROM sessions WHERE sessionID = "]] .. request.tokenID .. [["]])

    if suc ~= 0 then
        response.html.body = "Something went wrong. Please contact an admin.\nError: " .. tostring(suc)
    else
        body:goTo(" ", 0)
    end
elseif request.tokenAction == "edit" then
    response.html.forwardInternal = "editToken"
    response.tokenID = request.tokenID
    return response
end

response.html.body = body:generateCode()

return response 