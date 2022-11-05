return function(requestData)
    local cookie = env.dyn.getCookies(requestData)
    local token 

    if requestData.request and requestData.request.token then
        token = requestData.request.token
    elseif cookie and cookie.token then
        token = cookie.token
    else
        return false, "Can't find a sesssion token."
    end

    return env.dyn.Session.new(token)
end