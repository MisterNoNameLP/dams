return function(requestData)
    local body = _M._I.dyn.html.Body.new()
    local session = _M._I.dyn.getSessionByRequestData(requestData)
    
    if session == false then
        local body = _M._I.dyn.html.Body.new()
        body:goTo("login", 0)
        return false, body:generateCode()
    else
        return session, _M._I.dyn.User.new(session:getUserID())
    end
end