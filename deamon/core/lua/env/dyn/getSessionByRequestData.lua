return function(requestData)
    local cookie = _M._I.getCookies(requestData)
    local token 

    if requestData.request and requestData.request.token then
        token = requestData.request.token
    elseif cookie and cookie.token then
        token = cookie.token
    else
        return false, "Can't find a sesssion token."
    end

    return _M._I.Session.new(token)
end