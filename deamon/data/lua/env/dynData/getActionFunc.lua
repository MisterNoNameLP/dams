return function(path) --generates avtion/site functions.
    local siteCode = env.lib.ut.readFile(path)
    local tracebackPathNote = path

    tracebackPathNote = string.sub(tracebackPathNote, select(2, string.find(tracebackPathNote, "userData")) + 2)

    if not siteCode then
        return false, "File not found: " .. tracebackPathNote 
    end

    siteCode = "--[[" .. tracebackPathNote .. "]] local args = {...}; local requestData, request, cookie, Session = args[1], args[1].request, env.cookie, env.dyn.Session; " .. siteCode
    
    return load(siteCode)
end