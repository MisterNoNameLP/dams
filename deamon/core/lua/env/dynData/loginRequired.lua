return function(requestData)
    local body = _M._I.html.Body.new()
    local session = _M._I.getSessionByRequestData(requestData)
    
    if session == false then
        local body = _M._I.html.Body.new()
        body:goTo("login", 0)
        return false, body:generateCode()
    else
        return session, _M._I.User.new(session:getUserID())
    end
end