return function(path) --generates avtion/site functions.
    local siteCode = env.lib.ut.readFile(path)
    local tracebackPathNote = path

    tracebackPathNote = string.sub(tracebackPathNote, select(2, string.find(tracebackPathNote, "userData")) + 2)

    if not siteCode then
        return false, "File not found: " .. tracebackPathNote 
    end

    siteCode = "--[[" .. tracebackPathNote .. "]] local args = {...}; local _E, _D, requestData, request, header, cookie, Session, response, body = env, env.dyn, args[1], args[1].request, args[1].headers, env.cookie, env.dyn.Session, {html = {}, error = {}}, env.dyn.html.Body.new(); " .. siteCode
    
    return load(siteCode)
end