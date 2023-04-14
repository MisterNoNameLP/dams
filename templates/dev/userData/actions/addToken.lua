local session, user = env.dyn.loginRequired(requestData)
if session == false then
    response.html.body = user
    return response
end

do --error check
    local error = response.error
    response.html.forwardInternal = "error"
    error.headline = "Adding token failed"
    if request.name == "" then
        error.err = "Invalid token name"
        error.code = -150
    elseif request.expireTimeUnit ~= "never" and request.expireTimeValue == "" then
        error.err = "Invalid Expire time"
        error.code = -151
    end
end

if response.error.code == nil then
    local expireTime
    local suc, token

    if request.expireTimeUnit == "never" then
        expireTime = -1
    else
        local dateTable = os.date("*t")
        dateTable[request.expireTimeUnit] = dateTable[request.expireTimeUnit] + request.expireTimeValue
        expireTime = os.time(dateTable)
    end

    suc, err, token = env.dyn.Session.create(user, expireTime, request.name, request.description, requestData, 0)

    if suc then
        response.html.forwardInternal = "viewNewToken"
        response.token = token
    else
        response.error.err = "Database error"
        response.error.code = err
    end
end

return response