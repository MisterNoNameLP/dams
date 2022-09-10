return function(requestData)
    local body = env.dyn.html.Body.new()
    local session = env.dyn.getSessionByRequestData(requestData)
    
    if session == false then
        local body = env.dyn.html.Body.new()
        body:goTo("login", 0)
        return false, body:generateCode()
    else
        return session, env.dyn.User.new(session:getUserID())
    end
end