local session, user = env.dyn.loginRequired(requestData)
if session == false then
    response.html.body = user
    return response
end
session = nil

do --error check
    local error = response.error
    response.html.forwardInternal = "error"
    error.headline = "Editing token failed"
    if request.name == "" then
        error.err = "Invalid token name"
        error.code = -150
    elseif request.expireTimeUnit ~= "never" and request.expireTimeValue == "" then
        error.err = "Invalid Expire time"
        error.code = -151
    end
end

if response.error.code == nil then
    local session, err, msg = env.dyn.Session.new(request.tokenID, true)
    local expireTime
    local suc = {}

    if session == false then
        response.html.forwardInternal = "error"
        response.error.headline = "Editing token failed 22"
        response.error.err = msg
        response.error.code = err
        return response
    end

    if request.expireTimeUnit == "never" then
        expireTime = -1
    else
        local dateTable = os.date("*t")
        dateTable[request.expireTimeUnit] = dateTable[request.expireTimeUnit] + request.expireTimeValue
        expireTime = os.time(dateTable)
    end

    assert(session:setName(request.name))
    assert(session:setNote(request.description))
    assert(session:setExpireTime(expireTime))

    response.html.forwardInternal = "error"
    response.error.headline = "Token edited successfully"
    response.error.msg = "none"
    response.error.code = 0
end

return response